class Warehouse
	attr_reader :origin, :length, :width, :height, :area, :volume
	attr_accessor :curr_origin, :dimensions, :address

	def initialize(origin, dimensions, address=nil)
		# ensure that valid paramters for a 3D object (cuboid) is initialized.
		raise ArgumentError if dimensions.count < 3 || dimensions.any? { |dimen| dimen == 0 }
		raise 'Cannot instantiate without a valid origin' if origin.empty?

		@origin = origin
		@curr_origin = origin # need this in order not to mutate the initialized origin. Could have been duped but I opted to give it its own instance variable
		@dimensions = dimensions
		@length = dimensions[0].abs 
		@width = dimensions[1].abs 
		@height = dimensions[2].abs 
		@address = address # the mother container. 
		@area = (dimensions[0] * dimensions[1]).abs 
		@volume = (dimensions[0].abs * dimensions[1].abs * dimensions[2]).abs 
		@cuboid_stack ||= []
		# I considered adding weight, density, and fragility properties to help make safe packaging but I run out of time.
	end

	# The diagonals below are probably useless in this case but could be useful in anticipating future needs or problems such as repackaging or when angular rotations + translations of the cuboid become necessary
	def xy_diagonal
		Math.sqrt((@length ** 2) + (@width ** 2))
	end

	def yz_diagonal
		Math.sqrt((@width ** 2) + (@height ** 2))
	end

	def zx_diagonal
		Math.sqrt((@length ** 2) + (@height ** 2))
	end

	def xyz_diagonal
		Math.sqrt((@length ** 2) + (@width ** 2) + (@height ** 2))
	end

  def vertices
		verts = []
		verts << curr_origin # add curr_origin to the array
		# then cycle through the remaining 7 vertices to add them to the array
		# those with only one coordinate offset from the curr_origin
		verts << [curr_origin[0] + dimensions[0], curr_origin[1], curr_origin[2]]
		verts << [curr_origin[0], curr_origin[1] + dimensions[1], curr_origin[2]]
		verts << [curr_origin[0], curr_origin[1], curr_origin[2] + dimensions[2]]
		# those with two coordinate offsets from the curr_origin
		verts << [curr_origin[0], curr_origin[1] + dimensions[1], curr_origin[2] + dimensions[2]]
		verts << [curr_origin[0] + dimensions[0], curr_origin[1], curr_origin[2] + dimensions[2]]
		verts << [curr_origin[0] + dimensions[0], curr_origin[1] + dimensions[1], curr_origin[2]]
		# then finally add the one with all three coordinate offsets from the curr_origin
		verts << [curr_origin[0] + dimensions[0], curr_origin[1] + dimensions[1], curr_origin[2] + dimensions[2]]

		verts
  end
	
	def faces
		cuboid_faces = []
		# cycle through the origin indices and form pairs of front and back faces that are dimensions[idx] units away from each other.
		@curr_origin.each_with_index do |val, idx| 
			f_face, b_face = val, val + dimensions[idx]
			# sort the faces correctly before putting them in the cuboid_faces array to enable easy access to them when necessary.
			b_face > f_face ? cuboid_faces << [f_face, b_face] : cuboid_faces << [b_face, f_face]	
		end
		
		cuboid_faces
	end	

	# wanted to implement this method where each cuboid is automatically added to its parent container's cuboid_stack when initialized. This would enable a more efficient way to know where each cuboid is in the warehouse and to more efficiently avoid collisons or wasted energy in packing them.
	def add_cuboid(child_cuboid)
		@cuboid_stack << child_cuboid
	end
end