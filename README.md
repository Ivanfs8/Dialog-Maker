# Dialog-Maker

Godot 3 dialogue plugin using NodeGraph.
I learned a lot from making this plugin, but it grew out of scope and there are way better solutions with a lot more work behind them.


**Node Tree System:**
![Nodes Tree Demo](https://i.imgur.com/U29M7N4.png)


**Node Editor:**
![Node Editor Demo](https://i.imgur.com/lYWPMvG.png)
It's separate from the tree editor in the same dock as the inspector, allowing it to be resized individually


**Character Resource:**

![Character Demo](https://i.imgur.com/9dXUiCz.png)

## Node Types

**Start:** Defines the first node in the tree, you can choose the character's starting positions and expressions. There is no exit node, if a node is not connected further (no right socket connected) it will end the dialogue.

**Sequence:** Most node based dialogue editors force you to make a new node per character line, the sequence node instead allows you to make as many lines as you need with all available characters.

**Choice:** You can make a character ask a question, then add as many answers as you need. Each answer will add a new socket to the node for branching connections. The red left one is for inserting condition nodes.

**Condition:** Can only be connected to red sockets, they block branches with variables comparisons. Typically used for item checks or stat checks in RPGs

## How to play dialogue

You need two nodes
![Node Example](https://i.imgur.com/POO5FwK.png)
The dialog node just holds a reference to the dialogue resource you want to play, and a reference to the dialogue player. Use start_dialog() as you like to play the dialogue file.

The dialog player node is a premade scene that contains all possible character positions and the dialogue box. You need to define which input action will advance the dialogue in the inspector.
![Dialogue Player](https://i.imgur.com/w2H0gE5.png)
