echo "Hold BOOT and plug in the device now..."; \
read; \
sudo dmesg --clear; \
sleep 2; \
echo "--- dmesg output ---"; \
dmesg | tail -n 20; \
echo "--- lsblk output ---"; \
lsblk -f; \
echo "--- fdisk output ---"; \
sudo fdisk -l
