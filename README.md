DSDTChain - a Block Chain for Data Science & Data Technology implemented in Erlang
----------------------------------------------------------------------------

DSDTChain is a multi-party blockchain using Nakamoto consensus. It exists 
primarily as a distributed application and hopefully as an accessible
implementation people can explore to develop data science and big data applications.

Please note that this project is still under development. Many integrity checks and
security measures are continued to be complemented.

What can it do?
================

DSDTChain blocks can hold 3 transaction types: token base transactions (to pay
the miner for mining), payment transactions and data transactions.

DSDTChain nodes communicate via the internet using the libp2p library. As libp2p
gains features for traversing more complicated networks DSDTChain will inherit
those capabilities. Currently only simple topologies will work.

How to build it
===============

Run `make`.

If you want to run some checks; run `make check`.


How to use it
=============

To generate a genesis block for a DSDTChain blockchain you need to use the
genesis command:

    $ ./genesis.sh dsdt-miner1

This will start a node called `dsdt-miner1@127.0.0.1`, create a genesis block it
will write to a file called `dsdt-miner1@127.0.0.1-genesis.block`. You can now query
the state of the node with the status command:

    $ ./status dsdt-miner1

You'll see something like this:

```
Blockchain is of height 1 with head 2e71d9499f1a8cf883c6c2e970224aadfafa07f35fdc54ccc2a7c75572000000
Listen addresses are ["/ip4/192.168.11.137/tcp/38019"]
Miner address is 12r8dFpB28Ry6UeE31XKgfPdY9JmFUpXKGXrfN4FViwP1oGyhgN
Ledger
12r8dFpB28Ry6UeE31XKgfPdY9JmFUpXKGXrfN4FViwP1oGyhgN has 4035 with nonce 0
```

So from this we can see the blockchain only has 2 blocks in it, and the
`dsdt-miner1` miner has claimed 2 mining rewards.

Now we have a genesis block, we can invite other miners to the party:

    $ ./join.sh dsdt-miner2 dsdt-miner1@127.0.0.1-genesis.block /ip4/192.168.11.137/tcp/38019

We started a node called `dsdt-miner2` and gave it a copy of the genesis block and
the multiaddr that dsdt-miner1 is running on.

Let's add a third miner:

    $ ./join.sh dsdt-miner3 dsdt-miner1@127.0.0.1-genesis.block /ip4/192.168.11.137/tcp/38019

```
$ ./status.sh dsdt-miner1
Blockchain is of height 19 with head 69c990ef0df3296c085ee32b7d6fb1e7246fe0a9b0fafd5474c69184d6000000
Listen addresses are ["/ip4/192.168.11.137/tcp/38019"]
Miner address is 12r8dFpB28Ry6UeE31XKgfPdY9JmFUpXKGXrfN4FViwP1oGyhgN
Ledger
12qKXB8UiHfBNhTFCNkWZyiytptZBsFuyeL7LDc1w68PEt9rkBP has 20117 with nonce 0
12r8dFpB28Ry6UeE31XKgfPdY9JmFUpXKGXrfN4FViwP1oGyhgN has 14050 with nonce 0
12rcbanTv8nVgan2dzqbn39MNj6k4cBfkfhvacC9g4Xcn77JSv1 has 6003 with nonce 0

$ ./status.sh dsdt-miner2
Blockchain is of height 19 with head 69c990ef0df3296c085ee32b7d6fb1e7246fe0a9b0fafd5474c69184d6000000
Listen addresses are ["/ip4/192.168.11.137/tcp/34757"]
Miner address is 12qKXB8UiHfBNhTFCNkWZyiytptZBsFuyeL7LDc1w68PEt9rkBP
Ledger
12qKXB8UiHfBNhTFCNkWZyiytptZBsFuyeL7LDc1w68PEt9rkBP has 20117 with nonce 0
12r8dFpB28Ry6UeE31XKgfPdY9JmFUpXKGXrfN4FViwP1oGyhgN has 14050 with nonce 0
12rcbanTv8nVgan2dzqbn39MNj6k4cBfkfhvacC9g4Xcn77JSv1 has 6003 with nonce 0

$ ./status.sh dsdt-miner3
Blockchain is of height 19 with head 69c990ef0df3296c085ee32b7d6fb1e7246fe0a9b0fafd5474c69184d6000000
Listen addresses are ["/ip4/192.168.11.137/tcp/45277"]
Miner address is 12rcbanTv8nVgan2dzqbn39MNj6k4cBfkfhvacC9g4Xcn77JSv1
Ledger
12qKXB8UiHfBNhTFCNkWZyiytptZBsFuyeL7LDc1w68PEt9rkBP has 20117 with nonce 0
12r8dFpB28Ry6UeE31XKgfPdY9JmFUpXKGXrfN4FViwP1oGyhgN has 14050 with nonce 0
12rcbanTv8nVgan2dzqbn39MNj6k4cBfkfhvacC9g4Xcn77JSv1 has 6003 with nonce 0
```

So we can see the 3 miners have arrived at consensus (it can take a while). They
all have the same ledger values and all agree on the height of the blockchain
and the hash of the newest block.

Now, `dsdt-miner1` has quite a lot more money than `dsdt-miner3`, let's send
some money around:

```
$ ./spend.sh dsdt-miner1 1337 12rcbanTv8nVgan2dzqbn39MNj6k4cBfkfhvacC9g4Xcn77JSv1
Transaction <<"g2gGZAALcGF5bWVudF90eG5tAAAAIPNBTlpaQkGZW8/RtO5m3lvOev/IU3pYYdDXNNcheqEnbQAAACD0WaJ07I+IT4Tr3KX0T7YVL9U+tm9GNVvP90DbKDsNq2IAAAU5YQFtAAAASDBGAiEAmzeJ9bHFGylaq9/V9JYzD57X7Jtu/b779VaqkkR7VckCIQDNHvmIZKc1dn0sr4vomSGzBy6/Z7Sp5lMm2PXw5AtS7A==">> submitted
```

Now we have to wait a bit for it to clear. DSDTChain doesn't gossip transactions
(yet), so we have to wait for `dsdt-miner1` to mine a winning block...

Eventually we see it's happened:

```
$ ./status.sh dsdt-miner1
Blockchain is of height 44 with head 61953521fa69c8146c02d2cbb62a302c15e9caa28de803174baac7b809000000
Listen addresses are ["/ip4/192.168.11.137/tcp/38019"]
Miner address is 12r8dFpB28Ry6UeE31XKgfPdY9JmFUpXKGXrfN4FViwP1oGyhgN
Ledger
12qKXB8UiHfBNhTFCNkWZyiytptZBsFuyeL7LDc1w68PEt9rkBP has 43952 with nonce 0
12r8dFpB28Ry6UeE31XKgfPdY9JmFUpXKGXrfN4FViwP1oGyhgN has 28605 with nonce 1
12rcbanTv8nVgan2dzqbn39MNj6k4cBfkfhvacC9g4Xcn77JSv1 has 17263 with nonce 0
```

We can see that `dsdt-miner1`'s nonce has increased and some funds have moved
around.

This is about all DSDTChain can do, but hopefully it explains some of the ideas
behind blockchains and how they work.

Limitations
==========

There are a lot:

* Don't inject invalid transactions because right now they never
get removed from the mempool and so will contaminate all subsequent blocks you
try to mine.
* Nodes will discover each other over libp2p, but they don't yet establish
redundant connections. If you stop the node everyone is connected to, the
blockchain will fork.
* Blocks are now store in memory, so needs to have large memory machine
