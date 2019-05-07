
declare -a window_size
window_size=(100 150 200 250 400 500 800 1000)
declare -a ident
ident=(55 60 70)
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
