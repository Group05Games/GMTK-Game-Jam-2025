extends Node
class_name HexLayerAdapter

static func cell_world_center(hex_layer: Node, tile_info: Dictionary) -> Vector2:
	# tile_info may contain:
	#   { "layer": hex_layer, "axial": Vector2i(q, r), "cube": Vector3i(x,y,z) }
	# or { "layer": hex_layer, "world_pos": Vector2 }  (already computed)

	if tile_info.has("world_pos"):
		return tile_info["world_pos"]

	if tile_info.has("axial") and hex_layer and hex_layer.has_method("axial_to_world"):
		return hex_layer.call("axial_to_world", tile_info["axial"])

	if tile_info.has("cube") and hex_layer and hex_layer.has_method("cube_to_world"):
		return hex_layer.call("cube_to_world", tile_info["cube"])

	# Last resort
	return Vector2.ZERO
