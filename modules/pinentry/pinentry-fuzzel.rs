// Minimal pinentry speaking the Assuan subset rbw uses, delegating the
// UI to fuzzel --dmenu --password.

use std::io::{self, BufRead, Read, Write};
use std::process::{Command, Stdio};

const FUZZEL: &str = env!("FUZZEL");
const FUZZEL_ARGS: &str = env!("FUZZEL_ARGS");
const MESG_COLOR: &str = env!("MESG_COLOR");
const MESG_ERROR_COLOR: &str = env!("MESG_ERROR_COLOR");

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

fn percent_decode(s: &str) -> String {
    let b = s.as_bytes();
    let mut out = Vec::with_capacity(b.len());
    let mut i = 0;
    while i < b.len() {
        let decoded = if b[i] == b'%' && i + 2 < b.len() {
            match u8::from_str_radix(&s[i + 1..i + 3], 16) {
                Ok(c) => Some(c),
                Err(_) => None,
            }
        } else {
            None
        };
        match decoded {
            Some(c) => {
                out.push(c);
                i += 3;
            }
            None => {
                out.push(b[i]);
                i += 1;
            }
        }
    }
    String::from_utf8_lossy(&out).into_owned()
}

fn getpin(stdout: &mut impl Write, desc: &str, error: &str) -> io::Result<()> {
    let mut cmd = Command::new(FUZZEL);
    // Empty prompt on purpose; --prompt-only is still what makes fuzzel
    // skip reading menu entries from stdin.
    cmd.arg("--dmenu").arg("--password=⬤").arg("--prompt-only=");
    // fuzzel parses the mask character with the locale's multibyte
    // decoder; agents may spawn us without any locale in the environment.
    if std::env::var_os("LC_ALL").is_none()
        && std::env::var_os("LC_CTYPE").is_none()
        && std::env::var_os("LANG").is_none()
    {
        cmd.env("LC_CTYPE", "C.UTF-8");
    }
    let (mesg, color) = if !error.is_empty() {
        // nf-fa-triangle_exclamation
        (format!("\u{f071} {error}"), MESG_ERROR_COLOR)
    } else if !desc.is_empty() {
        // nf-fa-lock
        (format!("\u{f023} {desc}"), MESG_COLOR)
    } else {
        (String::new(), MESG_COLOR)
    };
    if !mesg.is_empty() {
        // Trailing blank line: fuzzel has no mesg<->prompt spacing option.
        cmd.arg(format!("--mesg={mesg}\n"));
        cmd.arg(format!("--message-color={color}"));
    }
    for arg in FUZZEL_ARGS.split('\n').filter(|a| !a.is_empty()) {
        cmd.arg(arg);
    }

    let mut child = cmd
        .stdin(Stdio::null())
        .stdout(Stdio::piped())
        .spawn()?;

    let mut pin = vec![0u8; PIN_MAX];
    // Best effort; the page the kernel pipe buffer lives on is out of our
    // hands anyway.
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
        // fuzzel exits 2 when the user dismisses the prompt; anything
        // else means it never got to ask (no compositor, bad args).
        if status.success() || status.code() == Some(2) {
            stdout.write_all(b"ERR 83886179 Operation cancelled <pinentry-fuzzel>\n")?;
        } else {
            let line = format!(
                "ERR 83886081 fuzzel failed with {} <pinentry-fuzzel>\n",
                match status.code() {
                    Some(code) => format!("exit code {code}"),
                    None => String::from("a signal"),
                }
            );
            stdout.write_all(line.as_bytes())?;
        }
        return stdout.flush();
    }

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

    stdout.write_all(b"D ")?;
    stdout.write_all(&enc[..enc_len])?;
    stdout.write_all(b"\nOK\n")?;
    let res = stdout.flush();

    zero(&mut pin);
    zero(&mut enc);
    res
}

fn main() -> io::Result<()> {
    let stdin = io::stdin();
    let mut stdout = io::stdout();

    writeln!(stdout, "OK Pleased to meet you")?;
    stdout.flush()?;

    let mut desc = String::new();
    let mut error = String::new();

    for line in stdin.lock().lines() {
        let line = line?;
        let line = line.trim();
        let (cmd, rest) = match line.split_once(' ') {
            Some((c, r)) => (c, r),
            None => (line, ""),
        };

        if cmd.eq_ignore_ascii_case("SETDESC") {
            desc = percent_decode(rest);
            writeln!(stdout, "OK")?;
        } else if cmd.eq_ignore_ascii_case("SETERROR") {
            error = percent_decode(rest);
            writeln!(stdout, "OK")?;
        } else if cmd.eq_ignore_ascii_case("GETPIN") {
            getpin(&mut stdout, &desc, &error)?;
            // Error messages only apply to the GETPIN they precede.
            error.clear();
        } else if cmd.eq_ignore_ascii_case("GETINFO") {
            if rest == "pid" {
                writeln!(stdout, "D {}", std::process::id())?;
            }
            writeln!(stdout, "OK")?;
        } else if cmd.eq_ignore_ascii_case("CONFIRM")
            || cmd.eq_ignore_ascii_case("MESSAGE")
        {
            // No button UI; refusing is the safe answer.
            writeln!(stdout, "ERR 83886179 Operation cancelled <pinentry-fuzzel>")?;
        } else if cmd.eq_ignore_ascii_case("RESET") {
            desc.clear();
            error.clear();
            writeln!(stdout, "OK")?;
        } else if cmd.eq_ignore_ascii_case("BYE") {
            writeln!(stdout, "OK closing connection")?;
            stdout.flush()?;
            return Ok(());
        } else {
            // SETTITLE, SETPROMPT, OPTION, SETKEYINFO, ... -- accepted
            // and ignored.
            writeln!(stdout, "OK")?;
        }
        stdout.flush()?;
    }

    Ok(())
}
