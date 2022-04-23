/// tsv config file from input argument
tsvPath = params.input
/// reference genome .fa file
//fasta = params.fasta

/// create channels from tsv config file
//bwaChan = Channel.empty()
inputChan = Channel.empty()

/// from tsv config file
tsvFile = file(tsvPath)
inputChan = extractFastq(tsvFile)

process cutadapt {

    //scratch true
    publishDir "${launchDir}/results/fastq_trimmed", mode: 'copy'

    input:
    set idPatient, gender, status, idSample, idRun, file1, file2 from inputChan

    output:
    tuple val(idPatient), file("${idPatient}.R1.trimmed.fastq.gz"), file("${idPatient}.R2.trimmed.fastq.gz") into bwaChan

    script:
    """
    cutadapt -a CTGTCTCTTATACACATCT -A CTGTCTCTTATACACATCT \
    -o ${idPatient}.R1.trimmed.fastq.gz \
    -p ${idPatient}.R2.trimmed.fastq.gz \
    $file1 $file2
    """
}

process bwa {

    scratch true
    publishDir "${launchDir}/results/bam", mode: 'copy'

    input:
    tuple val(idPatient), file("${idPatient}.R1.trimmed.fastq.gz"), file("${idPatient}.R2.trimmed.fastq.gz") from bwaChan

    output:
    tuple val(idPatient), file("${idPatient}_sorted.bam") into bamindexChan

    script:
    rg = "\"@RG\\tID:${idPatient}\\tSM:${idPatient}\\tLB:${idPatient}\\tPL:ILLUMINA\""
    bwa_index = params.index_bwa

    """
    bwa mem -R ${rg} -t 4 ${bwa_index} \
    ${idPatient}.R1.trimmed.fastq.gz \
    ${idPatient}.R2.trimmed.fastq.gz \
    | samtools view -bS /dev/stdin | samtools sort --threads 4 - > ${idPatient}_sorted.bam
    """

}

process bam_index {

    scratch true
    publishDir "${launchDir}/results/bam", mode: 'copy'

    input:
    tuple val(idPatient), file("${idPatient}_sorted.bam") from bamindexChan

    output:
    file "${idPatient}_sorted.bam.bai"

    script:
    """
    samtools index ${idPatient}_sorted.bam
    """
}



/// Define input file in format: "subject gender status sample lane fastq1 fastq2"
def returnStatus(it) {
    if (!(it in [0, 1])) exit 1, "Status is not recognized in TSV file: ${it}, see --help for more information"
    return it
}

def returnFile(it) {
    if (!file(it).exists()) exit 1, "Missing file in TSV file: ${it}, see --help for more information"
    return file(it)
}

def hasExtension(it, extension) {
    it.toString().toLowerCase().endsWith(extension.toLowerCase())
}

def checkNumberOfItem(row, number) {
    if (row.size() != number) exit 1, "Malformed row in TSV file: ${row}, see --help for more information"
    return true
}

def extractFastq(tsvFile) {
    Channel.from(tsvFile)
        .splitCsv(sep: '\t')
        .map { row ->
            def idPatient  = row[0]
            def gender     = row[1]
            def status     = returnStatus(row[2].toInteger())
            def idSample   = row[3]
            def idRun      = row[4]
            def file1      = returnFile(row[5])
            def file2      = "null"
            if (hasExtension(file1, "fastq.gz") || hasExtension(file1, "fq.gz") || hasExtension(file1, "fastq") || hasExtension(file1, "fq")) {
                checkNumberOfItem(row, 7)
                file2 = returnFile(row[6])
                if (!hasExtension(file2, "fastq.gz") && !hasExtension(file2, "fq.gz")  && !hasExtension(file2, "fastq") && !hasExtension(file2, "fq")) exit 1, "File: ${file2} has the wrong extension. See --help for more information"
                if (hasExtension(file1, "fastq") || hasExtension(file1, "fq") || hasExtension(file2, "fastq") || hasExtension(file2, "fq")) {
                    exit 1, "We do recommend to use gziped fastq file to help you reduce your data footprint."
                }
            }
            else if (hasExtension(file1, "bam")) checkNumberOfItem(row, 6)
            else "No recognisable extention for input file: ${file1}"

            [idPatient, gender, status, idSample, idRun, file1, file2]
        }
}
