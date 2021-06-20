# Simulation of the APx Algorithm 

The purpose of project is to simulate the algorithmic part of the APx FW based on the input patterns of the playback BRAMs. A testbench reads in these inputs stored in a text file, simulates the algorithms using the AXI-stream format, and writes the results to an output text file.

<!--- ########################################################################################### -->


# Testbench

The algorithm block is standardized with the following interface:
```vhdl
entity algoTopWrapper is
  generic (
    N_INPUT_STREAMS  : integer := 24;
    N_OUTPUT_STREAMS : integer := 24
    );
  port (
    -- Algo Control/Status Signals
    algoClk   : in  sl;
    algoRst   : in  sl;
    algoStart : in  sl;
    algoDone  : out sl := '0';
    algoIdle  : out sl := '0';
    algoReady : out sl := '0';

    -- AXI-Stream In/Out Ports
    axiStreamIn  : in  AxiStreamMasterArray(0 to N_INPUT_STREAMS-1);
    axiStreamOut : out AxiStreamMasterArray(0 to N_OUTPUT_STREAMS-1)
    );
end algoTopWrapper;
```
[Example of the algoTopWrapper.vhd](https://gitlab.cern.ch/GTT/APx/blob/master/top/rtl/algoTopWrapper.vhd)

The testbench supports two types of playback/capture formats.
1) Data for each link consisting of only 64 b payload data: [Text file with counting pattern and sideband off](./cnt_SBoff.txt)
2) Data for each link consisting of 64 b payload data and additional 8 b for sideband info (before payload data): [Text file with counting pattern and sideband on](./cnt_SBon.txt)

Each pattern BRAM (same for input or output links) stores up to 1024x 64 b (+8 b) words. Data for each link is organized in columns and stored as a (8 b +) 64 b hex number in pattern files. The output file is always format 2).

The selected format is relays on the pattern file itself with #Sideband tag. #Sideband OFF [ON|OFF]

Without this tag present in the file, the testbench assumes format 1) (#Sideband OFF).
These are the sideband bits:
Bit 0: tValid
Bit 1: tLast
Bit 2: SOF
Bit 3: FFO
Bit 4: CHKSM_Err
Bit 5: Link_Lock
Bit 6: FFO_Lock
Bit 7: Rsv

Data is organized in columns for both formats. Each column represents an individual link. An item in a row for each link represents a single clock cycle worth of information.
The start of actual pattern data is immediately preceded with #BeginData tag. Subsequently, lines starting with # within pattern data block is skipped by the testbench.

Additionally, the testbench supports configurable sequencing of individual links with respect to "algoStart" signal. The testbech reads the link sequencing config from the file upon detection of #LinkSeq tag. In case no tag is present, the testbech assumes that all links are sequenced in the same clock cycle as assertion of algoStart signal. 

## Instructions for tb_algoTopWrapper.vhd:

- Change the constants in the "Constant Definitions" section
- Change the start-up and general behavior of algoRst and algoStart in the sig_proc process

## Information/Observations:

- [input].txt: Avoid white spaces at the end of lines in the header
- [input].txt: Only supports hex values and the hex value must start with an x, e.g. 0x02468ace
- [output].txt: Be careful with the hex values of the output: If one bit is X than the entire hex value (4 bit) is X 

## Todo

- Link sequencing at "--todo: Read in LinkSeq" and starting according links later


<!--- ########################################################################################### -->


# Pattern generation script

As a convenience, a python script can generate some pattern files (format 1) for now), populating data with zeros, counter, or random data: [pattern_gen.py](./pattern_gen.py)
Here are examples how to run the script:
```sh
python3 pattern_gen.py --linkCnt 24 --wordCnt 512 --datatype rnd > rnd.txt
python3 pattern_gen.py --linkCnt 96 --wordCnt 1024 --datatype cnt > cnt.txt
```