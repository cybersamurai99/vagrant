# Run the control-plane node
vagrant up control-plane &

# Run the worker node 1
vagrant up node-01 &

# Run the worker node 2
vagrant up node-02 &

# Wait for all background processes to finish
wait
