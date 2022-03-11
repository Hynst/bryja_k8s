// Load params from nextflow.config

reference = '/mnt/shared/MedGen/bryja/reference/GRCm38.p6-93/index/BWA/GRCm38.p6-93'
// R1 = params.fastq_R1
// R2 = params.fastq_R2

process cutadapt {

    output:
    file 'reference.txt' into ref
    
    """
    echo '${reference}' > reference.txt
    """
}

process bwa {

    input:
    file reference from ref.flatten()
    
    output:
    stdout result

    """
    cat $reference
    """
}

result.view { it.trim() }
