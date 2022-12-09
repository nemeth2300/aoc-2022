package main

import (
	"bytes"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Node struct {
	name      string
	size      int
	directory bool
	parent    *Node
	children  map[string]*Node
}

func (node *Node) setNodeSize() int {
	var size int = node.size

	for _, child := range node.children {
		size = size + child.setNodeSize()
	}
	node.size = size
	return size
}

func (node *Node) sumSmallDirectories(treshold int) (sum int) {
	if node.directory && node.size <= treshold {
		sum = sum + node.size
	}
	for _, child := range node.children {
		sum = sum + child.sumSmallDirectories(treshold)
	}

	return sum
}

type InputInstruction struct {
	cdCommand *CDCommandInstruction
	lsLine    *LSLineInstruction
}
type CDCommandInstruction struct {
	destination string
}
type LSLineInstruction struct {
	directory bool
	name      string
	size      int
}

func parseLine(line string) (instruction InputInstruction) {
	if line == "" {
		return
	}
	parts := strings.Split(line, " ")
	if parts[0] == "$" {
		if parts[1] == "cd" {
			instruction.cdCommand = &CDCommandInstruction{}
			instruction.cdCommand.destination = parts[2]
		}
	} else {
		instruction.lsLine = &LSLineInstruction{}
		instruction.lsLine.name = parts[1]
		if parts[0] != "dir" {
			size, _ := strconv.ParseInt(parts[0], 10, 0)
			instruction.lsLine.size = int(size)
		} else {
			instruction.lsLine.directory = true
		}
	}
	return
}

func main() {
	file_path := "input.txt"
	input, _ := os.ReadFile(file_path)
	lines := bytes.Split(input, []byte("\n"))

	root_node := Node{
		name:      "/",
		size:      0,
		directory: true,
		parent:    nil,
		children:  map[string]*Node{},
	}
	root_node.parent = &root_node

	current_node := &root_node
	for _, line := range lines {
		instruction := parseLine(string(line))

		if instruction.cdCommand != nil {
			if instruction.cdCommand.destination == ".." {
				current_node = current_node.parent
			} else if instruction.cdCommand.destination == "/" {
				current_node = &root_node
			} else {
				current_node = current_node.children[instruction.cdCommand.destination]
			}
		} else if instruction.lsLine != nil {
			child_node := &Node{}
			child_node.name = instruction.lsLine.name
			child_node.size = instruction.lsLine.size
			child_node.directory = instruction.lsLine.directory
			child_node.parent = current_node
			child_node.children = map[string]*Node{}
			current_node.children[child_node.name] = child_node
		}
	}

	root_node.setNodeSize()
	sum := root_node.sumSmallDirectories(100_000)
	fmt.Println(sum)
}
