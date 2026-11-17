# Scripts

Personal collection of shell scripts, utilities, and `systemd` user units for automating my **GNOME/Linux** setup. Expects the repo at `~/Scripts`. **Written strictly for my machine** - not guaranteed to work anywhere else.

## Structure

<table>
  <thead>
    <tr>
      <th>Filepath</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><code>auto-chmod.sh</code></td>
      <td>Grants <code>+x</code> permissions to new scripts.</td>
    </tr>
    <tr>
      <td><code>auto-symlink.sh</code></td>
      <td>Automatically manages symbolic links.</td>
    </tr>
    <tr>
      <td><code>tray-reloader.sh</code></td>
      <td>Reloads <b>AppIndicator</b> at screen unlock.</td>
    </tr>
    <tr>
      <td><code>git-pusher.sh</code></td>
      <td>Automates basic <code>git</code> work operations.</td>
    </tr>
    <tr>
      <td colspan="2"><strong><code>python/</code></strong></td>
    </tr>
    <tr>
      <td><code>font-patcher.py</code></td>
      <td>Utility for patching fonts (includes assets).</td>
    </tr>
    <tr>
      <td colspan="2"><strong><code>systemd/</code></strong></td>
    </tr>
    <tr>
      <td><code>.service</code> extension</td>
      <td>Background units for automation scripts.</td>
    </tr>
    <tr>
      <td colspan="2"><strong><code>symlinks/</code></strong></td>
    </tr>
    <tr>
      <td>All symlinks filetypes</td>
      <td>Symlinks to environment CLI commands.</td>
    </tr>
    <tr>
      <td colspan="2"><strong><code>nautilus/</code></strong></td>
    </tr>
    <tr>
      <td>7z-extractor.sh</td>
      <td>Context menu extract archives using 7z.</td>
    </tr>
  </tbody>
</table>

## Dependencies

First of all, you need a modern `systemd`-based Linux distro (I'm running **CachyOS**).

* `inotify-tools` - filesystem watchers (`auto-chmod.sh`, `auto-symlink.sh`).
* `7zip` *(optional)* - versatile utility for extracting archives (`7z-extractor.sh`).
* **GNOME** *(optional)* - only for desktop-specific scripts (`tray-reloader.sh`).
* **AppIndicator** extension *(optional)* - specifically for `tray-reloader.sh`.

## Installation

I highly recommend cloning into `~/Scripts` as the paths within it are hardcoded.

```sh
# Clone the repository
git clone https://github.com/b3hav1/scripts.git ~/Scripts

# Make scripts executable
chmod +x ~/Scripts/*.sh

# Add symlinks dir to PATH (add in your ~/.*rc)
export PATH="$HOME/Scripts/symlinks:$PATH"

# Link systemd user units
mkdir -p ~/.config/systemd/user
ln -s ~/Scripts/systemd/*.service ~/.config/systemd/user/

# Reload and enable services
systemctl --user daemon-reload
systemctl --user enable --now auto-chmod.service auto-symlink.service

# Enable tray service (optional)
systemctl --user enable --now tray-reloader.service
```

## License
Copyright (c) 2026 b3hav1

This repository is licensed under the [MIT License](LICENSE).
