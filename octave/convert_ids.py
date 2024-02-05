ids = list(marker_verts.keys())
for id in ids:
    marker_verts[int(id)] = marker_verts.pop(id, None)

marker_verts_corr_ids = marker_verts