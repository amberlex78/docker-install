# Docker Auto-Installer for Linux Mint

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux%20Mint-green.svg)
![Bash](https://img.shields.io/badge/language-Bash-orange.svg)

A set of automated bash scripts to completely clean, prepare, and install Docker Engine and Docker Compose on Linux Mint (versions 20, 21, and 22). 

These scripts use the official Docker **DEB822** repository format and ensure that your system uses the correct upstream **Ubuntu codename** (e.g., `noble`, `jammy`, `focal`) rather than the Mint-specific codename, preventing "404 Not Found" repository errors.

## 🚀 Features

* **Complete Cleanup:** Removes old, conflicting packages (`docker.io`, `podman-docker`, `containerd`, `runc`).
* **Prerequisites Check:** Automatically installs necessary tools (`curl`, `ca-certificates`).
* **Official Keyring:** Securely downloads and configures the official Docker GPG key.
* **Smart Repo Configuration:** Automatically detects your OS version and adds the correct upstream Ubuntu repository.
* **Post-Installation Setup:** Automatically creates the `docker` group and adds your current user to it.

## 📋 Supported Versions

| Linux Mint Version | Ubuntu Base | Supported | Script File |
| :--- | :--- | :---: | :--- |
| **22.x (Wilma, Zena)** | 24.04 (Noble) | ✅ Yes | `docker-install-mint22.sh` |
| **21.x (Vanessa, etc.)**| 22.04 (Jammy) | ✅ Yes | `docker-install-mint21.sh` |
| **20.x (Ulyana, etc.)** | 20.04 (Focal) | ✅ Yes | `docker-install-mint20.sh` |
| 19.x (Tara, etc.) | 18.04 (Bionic)| ❌ EOL | *Unsupported / Removed* |

> **Note:** Linux Mint 19 is End of Life (EOL) and is no longer supported by this tool.

## ⚙️ Quick Start

### **1. Clone the repository:**

```bash
git clone [https://github.com/amberlex78/docker-install.git](https://github.com/amberlex78/docker-install.git)
cd docker-install
```

### **2. Make the script executable:** 

Choose the script corresponding to your Linux Mint version. For example, for Mint 22:

```Bash
chmod +x docker-install-mint22.sh
```

### **3. Run the installer:**


```Bash
./docker-install-mint22.sh
```

## ⚠️ Important Post-Installation Step

The script automatically adds your user to the `docker` group so you can run Docker commands without `sudo`. However, Linux requires you to refresh your user session for this group change to take effect.

**After the script finishes, you must:**

1. Log out of your desktop session and log back in (or simply reboot your computer).
2. Verify the installation by running:

```Bash
docker run hello-world
```

## 🛠 What exactly does this script do?

Transparency is important when running automated scripts with `sudo`. Here is the exact workflow:

1. Updates APT package indexes.
2. Stops any running `docker.socket` services.
3. Purges old/conflicting Docker packages and deletes `/var/lib/docker` (⚠️ **Warning:** This deletes existing containers/volumes).
4. Installs `curl` and `ca-certificates`.
5. Downloads Docker's official GPG key to `/etc/apt/keyrings/`.
6. Creates a new repository entry in `/etc/apt/sources.list.d/docker.sources`.
7. Installs `docker-ce`, `docker-ce-cli`, `containerd.io`, and build/compose plugins.
8. Adds the current `$USER` to the `docker` group.

## 🤝 Contributing

Pull requests are welcome! If you find a bug or have a suggestion, please open an issue first to discuss what you would like to change.
