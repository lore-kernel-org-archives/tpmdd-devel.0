From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v3 1/6] tpm: use tpm_buf functions to
 perform a PCR read
Date: Fri, 23 Jun 2017 12:56:07 +0200
Message-ID: <20170623105607.vsfltdblwczrj3qv@linux.intel.com>
References: <20170621142941.32674-1-roberto.sassu@huawei.com>
 <20170621142941.32674-2-roberto.sassu@huawei.com>
 <20170622101404.blfpqcryrbe35ha4@linux.intel.com>
 <7cea09d5-e213-8783-fabc-eb47fc601942@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7cea09d5-e213-8783-fabc-eb47fc601942@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roberto Sassu <roberto.sassu@huawei.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jun 22, 2017 at 01:54:29PM +0200, Roberto Sassu wrote:
> On 6/22/2017 12:14 PM, Jarkko Sakkinen wrote:
> > On Wed, Jun 21, 2017 at 04:29:36PM +0200, Roberto Sassu wrote:
> > > tpm2_pcr_read() now uses tpm_buf functions to build the TPM command
> > > to read a PCR. Those functions are preferred to passing a tpm2_cmd
> > > structure, as they provide protection against buffer overflow.
> > > 
> > > Also, tpm2_pcr_read() code has been moved to tpm2_pcr_read_tpm_buf().
> > > Callers have to pass a tpm_buf structure, an algorithm supported by
> > > the TPM and call tpm_buf_destroy(). The algorithm still cannot be
> > > passed to the TPM driver interface. This parameter has been introduced
> > > for determining the digest size of a given algorithm.
> > > 
> > > Moving tpm2_pcr_read() code to tpm2_pcr_read_tpm_buf() is necessary
> > > because callers of the new function obtain different information from
> > > the output buffer: tpm2_pcr_read() gets the digest, tpm2_do_selftest()
> > > will get the command return code and tpm2_get_pcr_allocation() will get
> > > the digest size.
> > > 
> > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > 
> > We want to migrate *everything* to use tpm_buf to the point that
> > tpm_transmit takes tpm_buf as parameter.
> > 
> > > ---
> > >  drivers/char/tpm/tpm2-cmd.c | 54 +++++++++++++++++++++++++++------------------
> > >  1 file changed, 32 insertions(+), 22 deletions(-)
> > > 
> > > diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> > > index 3a99643..afd1b63 100644
> > > --- a/drivers/char/tpm/tpm2-cmd.c
> > > +++ b/drivers/char/tpm/tpm2-cmd.c
> > > @@ -231,15 +231,37 @@ static const u8 tpm2_ordinal_duration[TPM2_CC_LAST - TPM2_CC_FIRST + 1] = {
> > >  	(sizeof(struct tpm_input_header) + \
> > >  	 sizeof(struct tpm2_pcr_read_in))
> > > 
> > > -#define TPM2_PCR_READ_RESP_BODY_SIZE \
> > > -	 sizeof(struct tpm2_pcr_read_out)
> > > -
> > >  static const struct tpm_input_header tpm2_pcrread_header = {
> > >  	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> > >  	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
> > >  	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
> > >  };
> > 
> > Remove this and move tpm2_pcr_read_out declaration before tpm2_pcr_read.
> > Its only a one shot helper structure for this function. You can take it
> > of from the union and delete tpm2_pcr_read_in completely.
> 
> This should be done in the next patch, because tpm2_pcrread_header
> and tpm2_pcr_read_in are still used by tpm2_do_selftest().

OK, understood.

> > > +static int tpm2_pcr_read_tpm_buf(struct tpm_chip *chip, int pcr_idx,
> > > +				 enum tpm2_algorithms algo, struct tpm_buf *buf,
> > > +				 char *msg)
> > 
> > This wrapper is unnecessary especially since the fallback path is still
> > in the responsiblity of the caller.
> 
> Please have a look at patches 2/6 and 3/6. It will be more clear why
> this change is necessary. Alternatively, instead of tpm_buf, I can add
> the command return code and the digest size as parameters of this
> function.

Look at tpm_transmit_cmd(). It returns the TPM error. You return
positive number from this function it is a TPM error. Digest size
could be an additional parameter, yes.

This is how it works elsewhere in the subsystem so it would be also
coherent.

> > > +{
> > > +	int rc;
> > > +	u8 pcr_select[TPM2_PCR_SELECT_MIN] = {0};
> > > +
> > > +	if (pcr_idx >= TPM2_PLATFORM_PCR)
> > > +		return -EINVAL;
> > > +
> > > +	rc = tpm_buf_init(buf, TPM2_ST_NO_SESSIONS, TPM2_CC_PCR_READ);
> > > +	if (rc)
> > > +		return rc;
> > > +
> > > +	pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
> > > +
> > > +	tpm_buf_append_u32(buf, 1);
> > > +	tpm_buf_append_u16(buf, algo);
> > > +	tpm_buf_append_u8(buf, TPM2_PCR_SELECT_MIN);
> > > +	tpm_buf_append(buf, (const unsigned char *)pcr_select,
> > > +		       sizeof(pcr_select));
> > > +
> > > +	return tpm_transmit_cmd(chip, NULL, buf->data, PAGE_SIZE, 0, 0, msg);
> > > +}
> > > +
> > >  /**
> > >   * tpm2_pcr_read() - read a PCR value
> > >   * @chip:	TPM chip to use.
> > > @@ -251,29 +273,17 @@ static const struct tpm_input_header tpm2_pcrread_header = {
> > >  int tpm2_pcr_read(struct tpm_chip *chip, int pcr_idx, u8 *res_buf)
> > >  {
> > >  	int rc;
> > > -	struct tpm2_cmd cmd;
> > > -	u8 *buf;
> > > -
> > > -	if (pcr_idx >= TPM2_PLATFORM_PCR)
> > > -		return -EINVAL;
> > > -
> > > -	cmd.header.in = tpm2_pcrread_header;
> > > -	cmd.params.pcrread_in.pcr_selects_cnt = cpu_to_be32(1);
> > > -	cmd.params.pcrread_in.hash_alg = cpu_to_be16(TPM2_ALG_SHA1);
> > > -	cmd.params.pcrread_in.pcr_select_size = TPM2_PCR_SELECT_MIN;
> > > -
> > > -	memset(cmd.params.pcrread_in.pcr_select, 0,
> > > -	       sizeof(cmd.params.pcrread_in.pcr_select));
> > > -	cmd.params.pcrread_in.pcr_select[pcr_idx >> 3] = 1 << (pcr_idx & 0x7);
> > > +	struct tpm_buf buf;
> > > +	struct tpm2_pcr_read_out *out;
> > > 
> > > -	rc = tpm_transmit_cmd(chip, NULL, &cmd, sizeof(cmd),
> > > -			      TPM2_PCR_READ_RESP_BODY_SIZE,
> > > -			      0, "attempting to read a pcr value");
> > > +	rc = tpm2_pcr_read_tpm_buf(chip, pcr_idx, TPM2_ALG_SHA1, &buf,
> > > +				   "attempting to read a pcr value");
> > >  	if (rc == 0) {
> > > -		buf = cmd.params.pcrread_out.digest;
> > > -		memcpy(res_buf, buf, TPM_DIGEST_SIZE);
> > > +		out = (struct tpm2_pcr_read_out *)&buf.data[TPM_HEADER_SIZE];
> > > +		memcpy(res_buf, out->digest, TPM_DIGEST_SIZE);
> > 
> > I think that when changes are made that involve TPM_DIGEST_SIZE, it
> > should be simply replaced with SHA1_DIGEST_SIZE. It's just a constant
> > that makes reading the code harder.
> 
> Ok. Should I also replace TPM_DIGEST_SIZE in tpm2_pcr_read_out
> with SHA512_DIGEST_SIZE, given that the algorithm can be specified?
> 
> Thanks
> 
> Roberto

You can declare it as u8 digest[] (or whatever the fiel name was).

Once the first two patches are in shape I'll test and apply them
to my tree so we step further with this.

/Jarkko
