using MLDatasets, DataFrames
using ProbabilisticCircuits

train_int = transpose(reshape(MNIST.traintensor(UInt8), 28*28, :));
test_int = transpose(reshape(MNIST.testtensor(UInt8), 28*28, :));

function bitsfeatures(data_int)
    data_bits = zeros(Bool, size(data_int,1), 28*28*8)
    for ex = 1:size(data_int,1), pix = 1:size(data_int,2)
        x = data_int[ex,pix]
        for b = 0:7
            if (x & (one(UInt8) << b)) != zero(UInt8)
                data_bits[ex, (pix-1)*8+b+1] = true
            end
        end
    end
    data_bits
end

train_bits = bitsfeatures(train_int);
test_bits = bitsfeatures(train_int);

# construct HCLT structure
train_df = DataFrame(train_bits, :auto);
num_hidden_cats = 32
@time circuit = hclt(size(train_bits,2); data = train_df, num_hidden_cats, num_trees = 1)
uniform_parameters!(circuit; perturbation = 0.4)

write("mnist_bits_hclt_$num_hidden_cats.jpc.gz", circuit)