import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

class Instruction {
    protected int cost;

    public int getCost() {
        return cost;
    }
}

class NoopInstruction extends Instruction {
    public NoopInstruction() {
        this.cost = 1;
    }
}

class AddXInstruction extends Instruction {
    private int value;

    public AddXInstruction(int value) {
        this.cost = 2;
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}

class InstructionNotFoundException extends Exception {
    public InstructionNotFoundException() {
        super("Unkown instruction");
    }
}

abstract class InstructionParser {
    public static Instruction parseInstruction(String line) throws InstructionNotFoundException {
        String[] parts = line.split(" ");
        String operationName = parts[0];
        if (operationName.equals("addx")) {
            int cost = Integer.parseInt(parts[1]);
            return new AddXInstruction(cost);
        }
        if (operationName.equals("noop")) {
            return new NoopInstruction();
        }
        throw new InstructionNotFoundException();
    }
}

class CPU {
    public CPUWatcher watcher;
    private int cycle = 0;
    private int x = 1;

    public void setX(int x) {
        this.x = x;
    }

    public int getX() {
        return x;
    }

    public int getCycle() {
        return cycle;
    }

    private void incrementCycle() {
        cycle++;
        watcher.onIncrementCycle();
    }

    public void processInstruction(Instruction instruction) {
        for (int i = 0; i < instruction.getCost(); i++) {
            incrementCycle();
        }
        if (instruction instanceof AddXInstruction) {
            processAddXInstruction((AddXInstruction) instruction);
        }
    }

    private void processAddXInstruction(AddXInstruction instruction) {
        x += instruction.getValue();
    }
}

class CPUWatcher {
    private CPU cpu;

    private int signalStrengthSum = 0;

    public CPUWatcher(CPU cpu) {
        this.cpu = cpu;
    }

    public void onIncrementCycle() {
        int cpuCycle = cpu.getCycle();
        int x = cpu.getX();

        if (cpuCycle % 40 == 20) {
            System.out.println(cpuCycle);
            int strength = cpuCycle * x;
            signalStrengthSum += strength;
        }
    }

    public int getSignalStrengthSum() {
        return this.signalStrengthSum;
    }
}

class Main {
    public static void main(String[] args) {
        new Main();
    }

    public Main() {
        try {
            solve();
        } catch (Exception e) {
            System.err.println(e);
        }
    }

    public void solve() throws IOException, InstructionNotFoundException {
        String fileName = "input.txt";
        BufferedReader reader = new BufferedReader(new FileReader(fileName));

        CPU cpu = new CPU();
        CPUWatcher watcher = new CPUWatcher(cpu);
        cpu.watcher = watcher;

        while (true) {
            String line = reader.readLine();
            if (line == null) {
                break;
            }
            Instruction instruction = InstructionParser.parseInstruction(line);
            cpu.processInstruction(instruction);
        }
        int result = watcher.getSignalStrengthSum();
        System.out.println(result);
        reader.close();
    }
}