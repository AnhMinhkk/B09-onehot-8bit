import glob
import sys
import os

# Cấu hình Qt chạy không cần màn hình đồ họa
os.environ["QT_QPA_PLATFORM"] = "offscreen"

import klayout.db as db
import klayout.lay as lay

gds_files = glob.glob("designs/b09_onehot_binary/runs/*/results/final/gds/*.gds")

if not gds_files:
    print("ERROR: Không tìm thấy file GDS trong thư mục runs!")
    sys.exit(1)

gds_path = sorted(gds_files)[-1]
output_png = "b09_layout.png"

print(f"Đang đọc file GDS: {gds_path}")
layout = db.Layout()
layout.read(gds_path)

view = lay.LayoutView()
view.load_layout(layout, True)
view.max_view()
view.save_image(output_png, 1280, 960)

print(f"Đã render layout thành công ra file: {output_png}")
