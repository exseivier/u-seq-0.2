#!/usr/bin/env python2.7

from sys import argv, exit

def load_log(filename):
    """
        Loads the useq.log output file from useq pipeline
        Requires the useq.log file and path
    """
    LOG = {}
    FHIN = open(filename, "r")
    for line in FHIN:
        line = line.strip("\n")
        line = line.split("=")
        if line[0] == "PID":
            PID = line[1]
            LOG[PID] = {}
        elif line[0] == "DB Path":
            LOG[PID]["DB"] = line[1]
        elif line[0] == "QUERY":
            LOG[PID]["QUERY"] = line[1]
        elif line[0] == "WINDOW_SIZE":
            LOG[PID]["WINDOW_SIZE"] = line[1]
        elif line[0] == "STEPS":
            LOG[PID]["STEPS"] = line[1]
        elif line[0] == "TOTAL_SEQS":
            LOG[PID]["TOTAL_SEQS"] = line[1]
        elif line[0] == "COMMAND":
            LOG[PID]["COMMAND"] = line[1]
            command_line = line[1].split("\t")
            LOG[PID]["EVAL"] = command_line[3].split(" ")[1]
            LOG[PID]["IDENT"] = command_line[5].split(" ")[1]
            LOG[PID]["QCOV"] = command_line[8].split(" ")[1]
            LOG[PID]["TASK"] = command_line[9].split(" ")[1]
            LOG[PID]["REWARD"] = command_line[10].split(" ")[1]
            LOG[PID]["PENALTY"] = command_line[11].split(" ")[1]
            LOG[PID]["GOPEN"] = command_line[12].split(" ")[1]
            LOG[PID]["GEXT"] = command_line[13].split(" ")[1]
        elif line[0] == "UNMAPPED_SEQS":
            LOG[PID]["UNMAPPED_SEQS"] = line[1]
        elif line[0] == "Begin" or line[0] == "End":
            continue
        else:
            print "[SUMMARIS][ERROR!] - " + line[0] + " Damn load_log!"
            exit(1)

    FHIN.close()
    return LOG

def load_useq_output(filename):
    """
        Loads the useq statistics output from folders cuff.*
        Requires the name of a file containing the paths of the useq.stats.txt files
        for every analysis
    """
    STATS = {}
    useq_stats_files = []
    FHIN = open(filename, "r")
    for line in FHIN:
        line = line.strip("\n")
        FILE = line + "/useq.stats.txt"
        PID = line.split(".")[1]
        STATS[PID] = {}
        FHIN_stats = open(FILE, "r")
        for line_stats in FHIN_stats:
            line_stats = line_stats.strip("\n")
            line_stats = line_stats.split("-")[1]
            line_stats = line_stats.split("=")
            STATS[PID][line_stats[0]] = line_stats[1]

    return STATS
    FHIN.close()

def aggregate_and_write_to_file(log, stat):
    """
        Agregate data from both hash tables based on PID and
        writes them to a output file
        Requires the two hash table objects
    """
    PIDS = log.keys()
    for PID in PIDS:
        ###///### AGGREGATE
    
def main():
    """
        MAIN FUNCTION
    """
    filename = argv[1]
    filename_stats = argv[2]
    log = load_log(filename)
    stat = load_useq_output(filename_stats)
    for idx, items in stat.iteritems():
        for key, value in items.iteritems():
            print "PID: " + idx + " key: " + key + " value: " + value + "\n"

if __name__ == "__main__": main()

