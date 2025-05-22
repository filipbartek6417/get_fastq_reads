version 1.0

task get_reads {
    
    input {
        String reference_path
        String r1
        String r2
    }
    
    command <<<
        apt-get update && apt-get install -y curl
        curl -o hs1.fa.gz ~{reference_path}
        curl -o r1.fa.gz ~{r1}
        curl -o r2.fa.gz ~{r2}
    >>>

    output {
        File reference = "hs1.fa.gz"
        File r1 = "r1.fa.gz"
        File r2 = "r2.fa.gz"
    }

    runtime {
        cpu: 32
        memory: "100G"
        disks: "local-disk 2000 SSD"
        docker: "ubuntu:latest"
    }
    
}

workflow get_fastq_reads {

  input {
    String r1 = "https://s3-us-west-2.amazonaws.com/human-pangenomics/working/HPRC_PLUS/HG002/raw_data/hic/downsampled/HG002.HiC_1_S1_R1_001.fastq.gz"
    String r2 = "https://s3-us-west-2.amazonaws.com/human-pangenomics/working/HPRC_PLUS/HG002/raw_data/hic/downsampled/HG002.HiC_1_S1_R2_001.fastq.gz"
    String reference_path = "https://hgdownload.soe.ucsc.edu/goldenPath/hs1/bigZips/hs1.fa.gz"
  }

  call get_reads {
    input:
      reference_path = reference_path,
      r1 = r1,
      r2 = r2
  }

  output {
    File reference = get_reads.reference
    File r1 = get_reads.r1
    File r2 = get_reads.r2
  }

}
