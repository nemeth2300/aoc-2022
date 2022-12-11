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
    public CPUSubscriber subscriber;
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
        subscriber.onIncrementCycle();
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

interface CPUSubscriber {
    public void onIncrementCycle();
}

class CRT implements CPUSubscriber {
    private int spriteWidth = 3;
    private int width = 40;
    private int height = 6;
    private CPU cpu;
    private char[] pixels;

    public CRT(CPU cpu) {
        this.cpu = cpu;
        this.pixels = new char[width * height];
    }

    public void onIncrementCycle() {
        int cpuCycle = cpu.getCycle();
        int x = cpu.getX();

        int colIndex = cpuCycle % 40;
        int pixelIndex = cpuCycle - 1;

        if (x <= colIndex && colIndex < x + spriteWidth) {
            pixels[pixelIndex] = '#';
        } else {
            pixels[pixelIndex] = '.';
        }
    }

    public String toString() {
        String result = "";
        for (int row = 0; row < height; row++) {
            for (int col = 0; col < width; col++) {
                result += pixels[row * width + col];
            }
            result += "\n";
        }
        return result;
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
        CRT crt = new CRT(cpu);
        cpu.subscriber = crt;

        while (true) {
            String line = reader.readLine();
            if (line == null) {
                break;
            }
            Instruction instruction = InstructionParser.parseInstruction(line);
            cpu.processInstruction(instruction);
        }
        String result = crt.toString();
        System.out.println(result);
        reader.close();
    }

}