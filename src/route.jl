function route(X::AbstractArray{S}, Y::AbstractArray{Int}, A::Vector, B::Vector) where {S}
    n, p = size(X)
    branch_size = size(A, 1)
    leaf_size = branch_size + 1
    Z = zeros(Int, n)
    num_error = 0
    C = zeros(Int, leaf_size)

    # Determine the leaf node for each sample and evaluate the error
    for i in 1:n
        node = 1
        while node <= branch_size
            if A[node] == 0
                node = 2 * node + 1
                continue
            end
            node = ifelse(X[i, A[node]] < B[node], 2 * node, 2 * node + 1)
        end
        leaf_node = node - branch_size
        Z[i] = leaf_node
    end

    # Compute the class for each leaf node
    n_samples = copy(C)
    for node_leaf in 1:leaf_size
        tmp_Y = Y[Z.==node_leaf]
        n_samples[node_leaf] = length(tmp_Y)
        if !isempty(tmp_Y)
            C[node_leaf] = mode(tmp_Y)
            num_error += sum(tmp_Y .!= C[node_leaf])
        end
    end

    return C, num_error#, n_samples
end
