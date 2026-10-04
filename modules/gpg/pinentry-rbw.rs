// Pinentry for gpg-agent that serves the pin from rbw, exec'ing a real
// pinentry when rbw can't provide it.

use std::io::{self, BufRead, Read, Write};
use std::os::unix::process::CommandExt;
use std::process::{Command, Stdio};

const RBW: &str = env!("RBW");
const RBW_ENTRY: &str = env!("RBW_ENTRY");
const FALLBACK_GUI: &str = env!("FALLBACK_GUI");
const FALLBACK_TTY: &str = env!("FALLBACK_TTY");

// Pins longer than this are rejected rather than reallocating the
// mlock'd buffer.
const PIN_MAX: usize = 4096;

extern "C" {
    fn mlock(addr: *const core::ffi::c_void, len: usize) -> i32;
}

fn zero(buf: &mut [u8]) {
    for b in buf.iter_mut() {
        unsafe { std::ptr::write_volatile(b, 0) };
    }
    std::sync::atomic::compiler_fence(std::sync::atomic::Ordering::SeqCst);
}

fn rbw_get() -> io::Result<Option<(Vec<u8>, usize)>> {
    let mut child = Command::new(RBW)
        .args(["get", RBW_ENTRY])
        .stdin(Stdio::null())
        .stdout(Stdio::piped())
        .spawn()?;

    let mut pin = vec![0u8; PIN_MAX];
    unsafe {
        mlock(pin.as_ptr() as *const core::ffi::c_void, pin.len());
    }

    let mut len = 0;
    let mut overflow = false;
    let mut out = child.stdout.take().unwrap();
    loop {
        if len == pin.len() {
            overflow = true;
            break;
        }
        match out.read(&mut pin[len..])? {
            0 => break,
            n => len += n,
        }
    }
    drop(out);
    let status = child.wait()?;

    while len > 0 && (pin[len - 1] == b'\n' || pin[len - 1] == b'\r') {
        len -= 1;
    }

    if !status.success() || len == 0 || overflow {
        zero(&mut pin);
        return Ok(None);
    }
    Ok(Some((pin, len)))
}

fn fallback() -> io::Error {
    let gui = std::env::var_os("WAYLAND_DISPLAY").is_some_and(|v| !v.is_empty());
    let path = if gui { FALLBACK_GUI } else { FALLBACK_TTY };
    // Only returns on failure.
    Command::new(path).args(std::env::args_os().skip(1)).exec()
}

fn main() -> io::Result<()> {
    // Fetch before touching stdin so the fallback pinentry can take over
    // the conversation from the start.
    let (mut pin, len) = match rbw_get()? {
        Some(pin) => pin,
        None => return Err(fallback()),
    };

    let mut enc = vec![0u8; PIN_MAX * 3];
    unsafe {
        mlock(enc.as_ptr() as *const core::ffi::c_void, enc.len());
    }
    let mut enc_len = 0;
    for &b in &pin[..len] {
        match b {
            b'%' | b'\r' | b'\n' => {
                enc[enc_len] = b'%';
                let hex = b"0123456789ABCDEF";
                enc[enc_len + 1] = hex[(b >> 4) as usize];
                enc[enc_len + 2] = hex[(b & 0xf) as usize];
                enc_len += 3;
            }
            _ => {
                enc[enc_len] = b;
                enc_len += 1;
            }
        }
    }
    zero(&mut pin);

    let stdin = io::stdin();
    let mut stdout = io::stdout();

    writeln!(stdout, "OK Pleased to meet you")?;
    stdout.flush()?;

    for line in stdin.lock().lines() {
        let line = line?;
        let line = line.trim();
        let (cmd, rest) = match line.split_once(' ') {
            Some((c, r)) => (c, r),
            None => (line, ""),
        };

        if cmd.eq_ignore_ascii_case("GETPIN") {
            stdout.write_all(b"D ")?;
            stdout.write_all(&enc[..enc_len])?;
            stdout.write_all(b"\nOK\n")?;
        } else if cmd.eq_ignore_ascii_case("GETINFO") {
            if rest == "pid" {
                writeln!(stdout, "D {}", std::process::id())?;
            }
            writeln!(stdout, "OK")?;
        } else if cmd.eq_ignore_ascii_case("BYE") {
            writeln!(stdout, "OK closing connection")?;
            stdout.flush()?;
            break;
        } else {
            writeln!(stdout, "OK")?;
        }
        stdout.flush()?;
    }

    zero(&mut enc);
    Ok(())
}
