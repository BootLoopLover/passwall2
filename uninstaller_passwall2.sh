#!/bin/sh

echo "[!] Menghapus Passwall2..."
opkg remove luci-app-passwall2 --force-removal-of-dependent-packages

echo "[!] Menghapus file konfigurasi Passwall2..."
rm -rf /etc/config/passwall2
rm -rf /etc/passwall2
rm -rf /usr/share/passwall2
rm -rf /usr/libexec/passwall2

echo "[!] Menghapus entri auto-start Passwall2 dari /etc/rc.local..."
sed -i '/passwall2 restart/d' /etc/rc.local
sed -i '/sleep 25/d' /etc/rc.local

echo "[!] Menghapus service Passwall2 jika masih ada..."
/etc/init.d/passwall2 stop 2>/dev/null
/etc/init.d/passwall2 disable 2>/dev/null
rm -f /etc/init.d/passwall2

echo "[!] Menghapus Xray-core..."
# Hapus binary Xray manual
if [ -f /usr/bin/xray ]; then
    rm -f /usr/bin/xray
    echo "    - Binary /usr/bin/xray dihapus."
fi

# Pulihkan backup jika ada
if [ -f /usr/bin/xray.bak ]; then
    mv /usr/bin/xray.bak /usr/bin/xray
    chmod +x /usr/bin/xray
    echo "    - Binary xray.bak dipulihkan ke /usr/bin/xray."
fi

# Jika terinstal lewat opkg, hapus juga
if opkg list-installed | grep -q '^xray-core'; then
    opkg remove xray-core
    echo "    - Paket xray-core dihapus melalui opkg."
fi

echo "[✓] Uninstall lengkap Passwall2 dan Xray-core selesai!"

