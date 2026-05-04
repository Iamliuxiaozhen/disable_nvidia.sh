#  SPDX-License-Identifier: Apache License 2.0 
# Copyright (c) 2026 Oliver

#!/bin/bash

# 禁用NVIDIA独立显卡脚本
# 适用于ThinkPad P50s的NVIDIA Quadro M500M

echo "正在禁用NVIDIA独立显卡..."

# 方法1：使用modprobe黑名单驱动
echo "将NVIDIA驱动加入黑名单..."
echo "blacklist nvidia" | sudo tee -a /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia_uvm" | sudo tee -a /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia_drm" | sudo tee -a /etc/modprobe.d/blacklist.conf
echo "blacklist nvidia_modeset" | sudo tee -a /etc/modprobe.d/blacklist.conf

# 方法2：使用nvidia-smi命令禁用
echo "使用nvidia-smi禁用GPU..."
sudo nvidia-smi -pm 1  # 禁用动态功耗管理
sudo nvidia-smi -pm 0  # 禁用GPU

# 方法3：创建Xorg配置文件强制使用集成显卡
echo "创建Xorg配置文件强制使用Intel集成显卡..."
sudo tee /etc/X11/xorg.conf.d/20-intel.conf > /dev/null <<EOF
Section "Device"
    Identifier "Intel Graphics"
    Driver "intel"
    BusID "PCI:0:2:0"
EndSection
EOF

# 生成新的initramfs以确保驱动被正确加载
echo "更新initramfs..."
sudo update-initramfs -u -k all

echo "完成！"
echo "重启系统后将只使用Intel集成显卡。"
echo "如果需要重新启用NVIDIA显卡，请删除 /etc/modprobe.d/blacklist.conf 中的NVIDIA条目并重启。"%                                                                                                                                                 
