require 'rspec'
require 'warehouse'

describe Warehouse do
  subject(:warehouse) { Warehouse.new([0, 0, 0], [100, 100, 50]) }

	describe '#initialize' do
    it 'successfully instantiates a new warehouse' do
      expect(warehouse).to be_a Warehouse
		end

		it 'instantiates with a default address of nil if not given' do
      expect(warehouse.address).to be_nil
		end

		it 'instantiates with an address for cuboids' do
			warehouse_address = Warehouse.new([1, 2, 5], [3, 6, 8])
			cuboid = Warehouse.new([5, 12, 7], [3, 5, 1], warehouse_address)
      expect(cuboid.address).not_to be_nil
		end

		it "does not allow instantiating without full dimensions" do
			expect { Warehouse.new([2,5,0], [2]) }.to raise_error(ArgumentError)
		end
		
		it "does not allow instantiating without a valid origin" do
        expect { Warehouse.new([], [1,2,3]) }.to raise_error("Cannot instantiate without a valid origin")
		end
	end
	

  context 'when not initialized with valid 3D parameters' do
    it 'raises an ArgumentError' do
      expect { Warehouse.new([0, 0, 0], [0, 1, 5]) }.to raise_error(ArgumentError)
		end
		
		it 'raises an ArgumentError' do
      expect { Warehouse.new([0, 0, 0], [1, 0, 5]) }.to raise_error(ArgumentError)
		end
		
		it 'raises an ArgumentError' do
      expect { Warehouse.new([0, 0, 0], [1, 5, 0]) }.to raise_error(ArgumentError)
    end
  end


  describe '#length' do
    it 'displays the value of length' do
      expect(warehouse.length).to eq(100)
    end
  end

  describe '#width' do
    it 'displays the value of width' do
      expect(warehouse.width).to eq(100)
    end
  end

  describe '#height' do
    it 'displays the value of height' do
      expect(warehouse.height).to eq(50)
    end
	end
	
	describe '#area' do
    it 'shows the area' do
      expect(warehouse.area).to eq(10000)
    end
  end

  describe '#volume' do
    it 'displays the value of volume' do
      expect(warehouse.volume).to eq(500000)
    end
	end
	
	describe '#xy_diagonal' do
    it 'displays the value of xy_diagonal' do
      expect(warehouse.xy_diagonal).to be_within(0.1).of(141.4213562373095)
    end
	end
	
	describe '#yz_diagonal' do
    it 'displays the value of yz_diagonal' do
      expect(warehouse.yz_diagonal).to be_within(0.1).of(111.80339887498948)
    end
	end
	
	describe '#zx_diagonal' do
    it 'displays the value of zx_diagonal' do
      expect(warehouse.zx_diagonal).to be_within(0.1).of(111.80339887498948)
    end
	end
	
	describe '#xyz_diagonal' do
    it 'displays the value of xyz_diagonal' do
      expect(warehouse.xyz_diagonal).to eq(150)
    end
  end

  describe '#vertices' do
    it 'displays an array of the vertices' do
      expect(warehouse.vertices).to match_array([[0, 0, 0], [100, 0, 0], [0, 100, 0], [0, 0, 50], [0, 100, 50], [100, 0, 50], [100, 100, 0], [100, 100, 50]])
    end
  end
end