##

declare -a laxo1=(1 -1 0 2)
declare -a laxo2=(1 -1 1 2)
declare -a laxo3=(3 -2 5 5)
declare -a moderate1=(5 -4 8 6)
declare -a moderate2=(5 -4 A 6)
declare -a hard1=(2 -7 2 4)
declare -a hard2=(2 -7 4 2)
declare -a hard3=(2 -5 2 4)
declare -a hard4=(2 -5 4 2)
declare -a names=(laxo1 laxo2 laxo3 moderate1 moderate2 hard1 hard2 hard3 hard4)
declare -A parameters=(\
	[laxo1]=${laxo1[@]} \
	[laxo2]=${laxo2[@]} \
	[laxo3]=${laxo3[@]} \
	[moderate1]=${moderate1[@]} \
	[moderate2]=${moderate2[@]}\
	[hard1]=${hard1[@]} \
	[hard2]=${hard2[@]}\
	[hard3]=${hard3[@]}\
	[hard4]=${hard4[@]})

declare -a window_size=(200 250)
declare -a identity=(55 60)
declare -a qcov=(90 95 100)

for name in ${names[@]};
do
	for size in ${window_size[@]};
	do
		for i in ${identity[@]};
		do
			for q in ${qcov[@]};
			do
				p=${parameters[$name]}
				p1=$([ ${p:0:2} == "A" ] && echo 10 || echo ${p:0:2})
				p2=$([ ${p:2:2} == "A" ] && echo 10 || echo ${p:2:2})
				p3=$([ ${p:4:2} == "A" ] && echo 10 || echo ${p:4:2})
				p4=$([ ${p:6:2} == "A" ] && echo 10 || echo ${p:6:2})
				useq --query /home/piruvato/dbase/query/abac.acmnp/Acalifornica.mnp.abac.genome.fas --db /home/piruvato/dbase/allBac/NoAutographa.txt --size $size --steps 50 --task blastn --evalue 1 --qcov $q --identity $i --reward $p1 --penalty $p2 --gopen $p3 --gext $p4
			done
		done
	done
done

