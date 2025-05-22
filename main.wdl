version 1.0

task get_reads {
    
    input {
        String reference_path
        String reads_path
    }
    
    command <<<
        apt-get update && apt-get install -y curl
        curl -o hs1.fa.gz ~{reference_path}
        curl -o porec.fa.gz ~{reads_path}
    >>>

    output {
        File reference = "hs1.fa.gz"
        File reads = "porec.fa.gz"
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
    String reads_path = "https://s3-us-west-2.amazonaws.com/human-pangenomics/submissions/5b73fa0e-658a-4248-b2b8-cd16155bc157--UCSC_GIAB_R1041_nanopore/HG002_R1041_PoreC/Dorado_v4/HG002_1_Dorado_v4_R1041_PoreC_400bps_sup.fastq.gz"
    String reference_path = "https://hgdownload.soe.ucsc.edu/goldenPath/hs1/bigZips/hs1.fa.gz"
  }

  call get_reads {
    input:
      reads_path = reads_path,
      reference_path = reference_path
  }

  output {
    File reference = get_reads.reference
    File reads = get_reads.reads
  }

}
