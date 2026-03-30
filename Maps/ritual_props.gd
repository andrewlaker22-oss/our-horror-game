extends Node

func _ready():
    var tombstones_node = get_node("../Tombstones")
    if not tombstones_node:
        return
        
    # Generate 12 tombstones in a wide circle around the central altar
    for i in range(12):
        var tombstone = CSGBox3D.new()
        tombstone.size = Vector3(0.6, 1.2, 0.2)
        var angle = i * (PI / 6.0) # 360 degrees / 12
        var radius = 8.0 # Distance from center
        var x = radius * cos(angle)
        var z = radius * sin(angle)
        
        tombstone.position = Vector3(x, 0.6, z)
        tombstone.rotation.y = -angle + PI/2.0 # Face the center
        tombstone.name = "Tombstone_" + str(i)
        
        # Add basic PSX shader material (placeholder)
        var mat = StandardMaterial3D.new()
        mat.albedo_color = Color(0.3, 0.3, 0.3)
        tombstone.material = mat
        
        tombstones_node.add_child(tombstone)
