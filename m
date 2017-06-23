From: Roberto Sassu <roberto.sassu@huawei.com>
Subject: Re: [tpmdd-devel] [PATCH v3 2/6] tpm: use tpm2_pcr_read_tpm_buf() in
 tpm2_do_selftest()
Date: Fri, 23 Jun 2017 12:22:52 +0200
Message-ID: <decc69b2-fdcb-a3fa-9219-dcf5e6bc739b@huawei.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
 <20170621142941.32674-3-roberto.sassu@huawei.com>
 <20170623095511.3yxnrzujwnaliozz@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170623095511.3yxnrzujwnaliozz@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 6/23/2017 11:55 AM, Jarkko Sakkinen wrote:
> On Wed, Jun 21, 2017 at 04:29:37PM +0200, Roberto Sassu wrote:
>> tpm2_do_selftest() performs a PCR read during the TPM initialization phase.
>> This patch replaces the PCR read code with a call to
>> tpm2_pcr_read_tpm_buf(). tpm2_do_selftest() parses the result of the
>> TPM command, in order to retrieve the return code.
>>
>> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
>
> Work this out with a call to tpm2_pcr_read() instead.

Would it be ok to add tpm_algo, return_code, digest_size and log_msg
as new parameters of tpm2_pcr_read()? If not, please let me know
how I can pass the command return code to tpm2_do_selftest() and
the digest size, for the algorithms supported by the TPM, to
tpm2_get_pcr_allocation().

Thanks

Roberto


> /Jarkko
>
>> ---
>>  drivers/char/tpm/tpm2-cmd.c | 32 ++++++++++----------------------
>>  1 file changed, 10 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
>> index afd1b63..6a9fe0d 100644
>> --- a/drivers/char/tpm/tpm2-cmd.c
>> +++ b/drivers/char/tpm/tpm2-cmd.c
>> @@ -227,16 +227,6 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
>>  	TPM_UNDEFINED		/* 18f */
>>  };
>>
>> -#define TPM2_PCR_READ_IN_SIZE \
>> -	(sizeof(struct tpm_input_header) + \
>> -	 sizeof(struct tpm2_pcr_read_in))
>> -
>> -static const struct tpm_input_header tpm2_pcrread_header = {
>> -	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
>> -	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
>> -	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
>> -};
>> -
>>  static int tpm2_pcr_read_tpm_buf(struct tpm_chip *chip, int pcr_idx,
>>  				 enum tpm2_algorithms algo, struct tpm_buf *buf,
>>  				 char *msg)
>> @@ -938,7 +928,8 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
>>  	unsigned int loops;
>>  	unsigned int delay_msec = 100;
>>  	unsigned long duration;
>> -	struct tpm2_cmd cmd;
>> +	struct tpm_buf buf;
>> +	tpm_cmd_header *header;
>>  	int i;
>>
>>  	duration = tpm2_calc_ordinal_duration(chip, TPM2_CC_SELF_TEST);
>> @@ -951,20 +942,17 @@ static int tpm2_do_selftest(struct tpm_chip *chip)
>>
>>  	for (i = 0; i < loops; i++) {
>>  		/* Attempt to read a PCR value */
>> -		cmd.header.in = tpm2_pcrread_header;
>> -		cmd.params.pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
>> -		cmd.params.pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
>> -		cmd.params.pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
>> -		cmd.params.pcrread_in.pcr_select[0] = 0x01;
>> -		cmd.params.pcrread_in.pcr_select[1] = 0x00;
>> -		cmd.params.pcrread_in.pcr_select[2] = 0x00;
>> -
>> -		rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd), 0, 0,
>> -				      NULL);
>> +		rc = tpm2_pcr_read_tpm_buf(chip, 0, TPM2_ALG_SHA1, &buf, NULL);
>> +		if (rc >= 0) {
>> +			header = (tpm_cmd_header *)buf.data;
>> +			rc = be32_to_cpu(header->out.return_code);
>> +		}
>> +
>> +		tpm_buf_destroy(&buf);
>> +
>>  		if (rc < 0)
>>  			break;
>>
>> -		rc = be32_to_cpu(cmd.header.out.return_code);
>>  		if (rc != TPM2_RC_TESTING)
>>  			break;
>>
>> --
>> 2.9.3
>>
>>
>> ------------------------------------------------------------------------------
>> Check out the vibrant tech community on one of the world's most
>> engaging tech sites, Slashdot.org! http://sdm.link/slashdot
>> _______________________________________________
>> tpmdd-devel mailing list
>> tpmdd-devel@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

-- 
HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
Managing Director: Bo PENG, Qiuen PENG, Shengli WANG
