require_relative 'warehouse'

class Cuboid < Warehouse 
	def move_to!(x, y, z)
		# if all of the new coordiantes are within the walls then and there are no obstacles, then move box to new position
		@curr_origin = [x, y, z] if no_obstacle?(x, y, z)
		# There should be no need to update the vertices or faces since they are not hard coded (I set them up so they are always computed from the curr_origin)
	end

	#returns true if the two cuboids intersect each other.  False otherwise.
	def intersects?(other_cuboid)
		overlaps_along_x_with?(other_cuboid) && overlaps_along_y_with?(other_cuboid) && overlaps_along_z_with?(other_cuboid)
	end
	
	# I am assuming that an axis of rotation and angle + direction(sign) is given
	def rotate_by(angle, axis)
		# rotate only if cuboid is rotatable
		# determine the new dimensions for the cuboid from the old position and the given angle and axis of rotation
		# To achieve this, hold the index corresponding to the given 'axis' fixed and swap the other two idices. This is because there will be no change in dimensions in the axis of rotation. The other two indices are swapped beacuse they are perpendicular to each other and the angle of rotation is 90 degrees per rotation. The direction of rotation will be determined by the sign of the angle, where I take positive angles to be clockwise and negative angles to be counter-clockwise
		num_of_rotations = angle.abs / 90 # determine how many roations to make

		while num_of_rotations > 0 
			pivot = angle <= 0 ? (-1) : 1 # determine the sign from the angle. The pivot will either roatate towards the origin (0,0,0) or away from it
			if axis == 0
				@curr_origin = [curr_origin[0], curr_origin[1], curr_origin[2] + dimensions[2] * pivot]
				@dimensions = [dimensions[0], dimensions[2], dimensions[1]]
			elsif axis == 1
				@curr_origin = [curr_origin[0] + dimensions[0] * pivot, curr_origin[1], curr_origin[2]]
				@dimensions = [dimensions[2], dimensions[1], dimensions[0]]	
			else 
				@curr_origin = [curr_origin[0], curr_origin[1] + dimensions[1] * pivot, curr_origin[2]]
				@dimensions = [dimensions[0], dimensions[1], dimensions[2]]
			end

			num_of_rotations -= 1 # ignore angles smaller than 90 and round down thsoe greater than 90 to the nearest multiple of 90.
		end

		[@curr_origin, @dimensions] # return the curr_origin and dimensions to confirm rotation was successful
	end

	#Protected methods that can be called by other instances of the same class
	protected
	def dimensional_pair(idx)
		[curr_origin[idx], curr_origin[idx] + dimensions[idx]]
	end

	def is_dimensionally_within?(axis1, axis2)
		axis1.all? { |val| val.between?(axis2.first, axis2.last) } 
	end

	def overlaps_along_x_with?(other_cuboid)
		axis1 = self.dimensional_pair(0).sort
		axis2 = other_cuboid.dimensional_pair(0).sort
		(axis1.first > axis2.first && axis1.first < axis2.last) || (axis1.last > axis2.first && axis2.last < axis2.last) || is_dimensionally_within?(axis1, axis2) || is_dimensionally_within?(axis2, axis1)
	end

	def overlaps_along_y_with?(other_cuboid)
		axis1 = self.dimensional_pair(1).sort
		axis2 = other_cuboid.dimensional_pair(1).sort
		(axis1.first > axis2.first && axis1.first < axis2.last) || (axis1.last > axis2.first && axis2.last < axis2.last) || is_dimensionally_within?(axis1, axis2) || is_dimensionally_within?(axis2, axis1)
	end

	def overlaps_along_z_with?(other_cuboid)
		axis1 = self.dimensional_pair(2).sort
		axis2 = other_cuboid.dimensional_pair(2).sort
		(axis1.first > axis2.first && axis1.first < axis2.last) || (axis1.last > axis2.first && axis2.last < axis2.last) || is_dimensionally_within?(axis1, axis2) || is_dimensionally_within?(axis2, axis1)
	end


	private
	def warehouse_wall_violation
		# there is no intersection between box and any warehouse wall	
		# For now I will just return false, but in practice I would need to implement this method to make sure that there is no intersection between the cuboid and any of the walls of the warehouse. using the dimensions and origin of the warehouse I could check to see if there is a violation between any of the walls and any of the faces of the cuboid.
		false
	end

	def neghboring_cuboid_violation
		# there is no intersection between cuboid and any other cuboid
		# For now I will just return false, but in practice I would need to implement this method to make sure that there is no intersection between the cuboid and any of the neighboring cuboids. For example I might write a method to determine which cuboids are neighbors, and then call the intersects? method on each of them against self to ensure there is no intersection.
		false
	end

	def no_obstacle?(x, y, z)
		!warehouse_wall_violation && !neghboring_cuboid_violation
	end

	def rotatable?(next_position)
		# there is enough room at destination postion to contain cuboid and there is no obstruction between current position and destination position and 
		# there is enough room for the 2D diagonal to clear along the rotation axis. Again, I will just return true for now, but in practice I would need to implement this method to check if there are no obstructing neighboring cuboids and there is enough room for the xyz diagonal to clear in the rotation direction.
		true
	end
end