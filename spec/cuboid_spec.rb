require 'rspec'
require 'cuboid'

describe Cuboid do
	subject(:warehouse) { Warehouse.new([0, 0, 0], [100, 100, 50]) }
	subject(:cuboid) { Cuboid.new([0, 0, 0], [1, 2, 3], warehouse) }
	
	describe '#move_to!' do
		it "changes the origin in the simple happy case" do
			cuboid.move_to!(1, 2, 3)
      expect(cuboid.curr_origin == [1,2,3]).to be true
    end

		context "when there is enough room and no other cuboid in the way" do
			it "doesn't change a cuboid's position unless invoked" do
        expect(cuboid.curr_origin).to eq([0, 0, 0])
			end
			
			it "doesn't alter the cuboids position unless a change occurs" do
				cuboid.move_to!(0, 0, 0)
        expect(cuboid.curr_origin).to eq([0, 0, 0])
			end
			
			it 'moves the cuboid from its current position to the new position' do
				cuboid.move_to!(12, 13, 17)
        expect(cuboid.curr_origin).to eq([12, 13, 17])
      end

      it 'ensures the vertices are updated' do
        expect(cuboid.vertices).to match_array([[0, 0, 0], [0, 0, 3], [0, 2, 0], [0, 2, 3], [1, 0, 0], [1, 0, 3], [1, 2, 0], [1, 2, 3]])
      end
		end 
	end

	describe '#intersects?' do
		context 'when only one pair of axes overlap' do
      let(:cuboid_2) { Cuboid.new([0, 1, 0], [2, 2, 2], warehouse) }

      it 'returns false' do
        expect(cuboid.intersects?(cuboid_2)).to be false
      end
		end
		
		context 'when only two pair of axes overlap' do
      let(:cuboid_3) { Cuboid.new([6, 8, 12], [2, 2, 3], warehouse) }

      it 'returns false' do
        expect(cuboid.intersects?(cuboid_3)).to be false
      end
		end
		
    context 'when all three pair of axes intersects' do
      let(:cuboid_4) { Cuboid.new([0, 0, 2], [1, 1, 1], warehouse) }

      it 'returns true' do
        expect(cuboid.intersects?(cuboid_4)).to be true
      end
		end
		
		context 'when the faces are touching but not intersecting' do
			let(:cuboid_5a) { Cuboid.new([0, 0, 3], [1, 2, 3], warehouse) }
			let(:cuboid_5b) { Cuboid.new([0, 2, 0], [1, 2, 3], warehouse) }
			let(:cuboid_5c) { Cuboid.new([1, 0, 0], [1, 2, 3], warehouse) }

      it 'returns false' do
				expect(cuboid.intersects?(cuboid_5a)).to be false
				expect(cuboid.intersects?(cuboid_5b)).to be false
				expect(cuboid.intersects?(cuboid_5c)).to be false
      end
    end

    context 'when one cuboid engulfs another cuboid' do
			let(:cuboid_6a) { Cuboid.new([5, 5, 5], [4, 4, 4], warehouse) }
			let(:cuboid_6b) { Cuboid.new([6, 6, 6], [1, 1, 1], warehouse) }

      it 'returns true' do
        expect(cuboid_6a.intersects?(cuboid_6b)).to be true
      end
		end

    context "when there is no overlap in any pair of axes" do
      let(:cuboid_7) { Cuboid.new([23, 30, 11], [2, 4, 6], warehouse) }

      it 'returns false' do
        expect(cuboid.intersects?(cuboid_7)).to be false
      end
    end
  end

  describe '#rotate_by' do	
		context "when rotation is possible" do
			before(:each) do
				@cuboid = Cuboid.new([10, 5, 12], [2, 3, 4], warehouse)
			end
			it 'rotates the cuboid 90 degrees about the x-axis' do
        expect(@cuboid.rotate_by(90, 0)).to match_array([[10, 5, 16], [2, 4, 3]])
			end

			it 'rotates the cuboid 90 degrees about the y-axis' do
        expect(@cuboid.rotate_by(90, 1)).to match_array([[12, 5, 12], [4, 3, 2]])
			end

      it 'rotates the cuboid 90 degrees about the  z-axis' do
        expect(@cuboid.rotate_by(90, 2)).to match_array([[10, 8, 12], [2, 3, 4]])
			end
			
			it 'rotates the cuboid -90 degrees about the indicated axis' do
        expect(@cuboid.rotate_by(-90, 1)).to match_array([[8, 5, 12], [4, 3, 2]])
      end

			it 'does 180 angle rotation' do
				expect(@cuboid.rotate_by(-180, 2)).to match_array([[10, -1, 12], [2, 3, 4]])
			end
			
			it 'does 270 angle rotation' do
				expect(@cuboid.rotate_by(270, 1)).to match_array([[18, 5, 12], [4, 3, 2]])
			end
			
			it 'does 360 angle rotation' do
				expect(@cuboid.rotate_by(360, 0)).to match_array([[10, 5, 26], [2, 3, 4]])
			end
			
			it 'does an arbitrarily large angle rotation' do
				expect(@cuboid.rotate_by(1260, 1)).to match_array([[52, 5, 12], [2, 3, 4]])
      end

			it 'updates the vertices of the cuboid' do
				expect(@cuboid.rotate_by(-90, 1)).to match_array([[8, 5, 12], [4, 3, 2]])
				expect(@cuboid.vertices).to match_array([[8, 5, 12], [12, 5, 12], [8, 8, 12], [8, 5, 14], [8, 8, 14], [12, 5, 14], [12, 8, 12], [12, 8, 14]])
			end
		end
	end 
end 