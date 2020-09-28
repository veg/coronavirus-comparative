## run this:

```
snakemake -s {snakefile} --cluster-config cluster.json --cluster "qsub -V -o torque -e torque -l nodes={cluster.nodes}:ppn={cluster.ppn}" --jobs 130 all --rerun-incomplete --keep-going
```

## ALL DATA IS IN:
```
/data/shares/veg/SARS-CoV-2/coronavirus-comparative-data/data
```


## Comparison of Selection with the Alpha and Beta Coronavirus Sub Families

#### TL;DR:
All data used in this comparative analysis comes from open sources: [VIPR](https://www.viprbrc.org/brc/home.spg?decorator=corona) and [NCBI](https://www.ncbi.nlm.nih.gov/).
This analysis compares evolutionary fingerprints of shared genes across viruses in the coronaviridae virus family. 

REQUIREMENTS:

- [Anaconda3](https://www.anaconda.com/distribution/)

- [HyPhy](https://github.com/veg/hyphy) Version ```2.5.18```

## Step 1. Set Up:
```
git clone https://github.com/veg/coronavirus-comparative.git
cd coronavirus-comparative
```

## Step 2: Set up an environment to run the analysis, using ```conda```:
```
conda env create -f environment.yml

conda activate viran
```

### If you are getting a ```conda``` error when trying to solve the environment, try 

```
conda upgrade -n base conda
```

## Step 3: Get the relevant HyPhy Repos:
```
bash scripts/hyphy_installer.sh
```

## At this point make sure to edit the `LIBPATH` variable in the Snakefile to make it explicit for your LIBPATH
### It should look like ```"/home/{user}/coronavirus-comparative/hyphy-develop/res"```


########## Need to finish this part #####
## Step 4: Move around data:
-- The data is tar-balled and dated, so:

```
unzip tar_ball/{dated_tar_ball_to_use}
unzip tar_ball/fasta_info.zip
A
unzip tar_ball/refs.zip
A
```


## Step 5: Run the pipeline with snakemake

we start by building [codon-aware MSAs](https://github.com/veg/hyphy-analyses/tree/master/codon-msa)

```
snakemake -s {snakefile} --cluster-config cluster.json --cluster "qsub -V -o torque -e torque -l nodes={cluster.nodes}:ppn={cluster.ppn}" --jobs 130 all --rerun-incomplete --keep-going

bpsh 3 snakemake data/new_fasta/ALL_S.fasta_protein_aligned.cat.merged.compressed.codon.fas 
```

Then you can run the selection analyses on the codon aware MSA, along with the associated tree. Just run:
```
bpsh 3 snakemake data/new_fasta/ALL_S.fasta_protein_aligned.cat.merged.compressed.codon.fas.ALL.json
```

This will run all selection anlaysis tools on the host and selected gene, these tools include:
   
  
  - [MEME](https://www.ncbi.nlm.nih.gov/pubmed/22807683)
  
  - [FEL](https://www.ncbi.nlm.nih.gov/pubmed/15703242)
  
  - [FUBAR](https://www.ncbi.nlm.nih.gov/pubmed/23420840)
  
  - [SLAC](https://www.ncbi.nlm.nih.gov/pubmed/15703242) 
  
  - [aBSREL](https://academic.oup.com/mbe/article/32/5/1342/1130440)

  - [BUSTEDS](https://academic.oup.com/mbe/article/doi/10.1093/molbev/msaa037/5739973)


Recombination is also tested for using:

  - [GARD](https://academic.oup.com/mbe/article/23/10/1891/1096946)


If you want to run just one analysis, it can be done this way:
```
bpsh 3 snakemake dasta/new_fasta/ALL_S.fasta_protein_aligned.cat.merged.compressed.codon.fas.MEME.json
```

-- you can use a ```-j``` flag to denote the number of cores to run on.

If you are on the server:

-- try to use ```bpsh 2``` to send the process somewhere besides the head node

