import glob
import sys
import klayout.db as db
import klayout.lay as lay

gds_files = glob.glob("designs/b09_onehot_binary/runs/*/results/final/gds/*.gds")

if not gds_files:
    print("Không tìm thấy file GDS!")
    sys.exit(1)

gds_path = sorted(gds_files)[-1]
output_png = "b09_layout.png"

layout = db.Layout()
layout.read(gds_path)

view = lay.LayoutView()
view.load_layout(layout, True)
view.max_view()
view.save_image(output_png, 1280, 960)

print(f"Đã render layout thành công: {output_png}")
