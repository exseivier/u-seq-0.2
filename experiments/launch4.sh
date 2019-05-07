## S100 I80 Q90
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 100 --steps 50 --task blastn --evalue 1 --qcov 90 --identity 80 --reward 1 --penalty -1 --gopen 1 --gext 2
#
## S100 I80 Q95
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 100 --steps 50 --task blastn --evalue 1 --qcov 95 --identity 80 --reward 1 --penalty -1 --gopen 1 --gext 2
#
## S100 I80 Q100
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 100 --steps 50 --task blastn --evalue 1 --qcov 100 --identity 80 --reward 1 --penalty -1 --gopen 1 --gext 2
#
## S150 I80 Q90
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 150 --steps 50 --task blastn --evalue 1 --qcov 90 --identity 80 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 150 --steps 50 --task blastn --evalue 1 --qcov 95 --identity 80 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 150 --steps 50 --task blastn --evalue 1 --qcov 100 --identity 80 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 200 --steps 50 --task blastn --evalue 1 --qcov 90 --identity 80 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 200 --steps 50 --task blastn --evalue 1 --qcov 95 --identity 80 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 200 --steps 50 --task blastn --evalue 1 --qcov 100 --identity 80 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 400 --steps 50 --task blastn --evalue 1 --qcov 95 --identity 100 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 500 --steps 50 --task blastn --evalue 1 --qcov 90 --identity 100 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 500 --steps 50 --task blastn --evalue 1 --qcov 95 --identity 100 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 800 --steps 50 --task blastn --evalue 1 --qcov 90 --identity 100 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 800 --steps 50 --task blastn --evalue 1 --qcov 95 --identity 100 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 1000 --steps 50 --task blastn --evalue 1 --qcov 90 --identity 100 --reward 1 --penalty -1 --gopen 1 --gext 2
#
#useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size 1000 --steps 50 --task blastn --evalue 1 --qcov 95 --identity 100 --reward 1 --penalty -1 --gopen 1 --gext 2


declare -a window_size
window_size=(100 150 200 250 400 500 800 1000)
declare -a ident
ident=(80 85)
declare -a qcov
qcov=(90 95 100)

for size in ${window_size[@]};
do
	for i in ${ident[@]};
	do
		for q in ${qcov[@]};
		do
			useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size $size --steps 50 --task blastn --evalue 1 --qcov $q --identity $i --reward 1 --penalty -1 --gopen 1 --gext 2
		done
	done
done
