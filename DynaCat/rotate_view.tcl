# Load the right hemisphere surface
viewer_3d 1
FileSurface 1 $rh_surf

# Set viewport 3d
set view_3d 1

# Rotate the view 180 degrees around the Z-axis (Yaw)
rotate $view_3d 0 0 180

# Zoom to fit the view
zoom_to_fit $view_3d

