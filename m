From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 1/2] tpm: implement TPM 2.0 capability to
 get active PCR banks
Date: Sun, 9 Oct 2016 13:21:15 +0300
Message-ID: <20161009102115.GA733@intel.com>
References: <1475979357-1167-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1475979357-1167-2-git-send-email-nayna@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1475979357-1167-2-git-send-email-nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sat, Oct 08, 2016 at 10:15:56PM -0400, Nayna Jain wrote:
> As per the TCG 2.0 spec, the extend operation should be done to
> all active PCR banks. However, current TPM 2.0 support doesn't
> have the capability implemented to get active PCR banks.
> 
> This patch implements the TPM 2.0 capability TPM_CAP_PCRS to
> retrieve active PCR banks from the TPM.
> 
> Signed-off-by: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

I'll try to give some guidelines how to get this done.

> +#define TPM2_GET_CAPABILITY_IN_SIZE \
> +	(sizeof(struct tpm_input_header) + \
> +	 sizeof(struct tpm2_get_cap_in))
> +
> +static const struct tpm_input_header tpm2_get_capability_header = {
> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(TPM2_GET_CAPABILITY_IN_SIZE),
> +	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
> +};
> +
> +int tpm2_get_capability(struct tpm_chip *chip, struct tpm2_get_cap_in *cap_in,
> +			struct tpm2_get_cap_out *cap_out)
> +{
> +
> +	struct tpm2_cmd cmd;
> +	int rc;
> +	u32 cap_id;
> +
> +	cmd.header.in = tpm2_get_capability_header;
> +	cmd.params.get_cap_in.cap_id = cpu_to_be32(cap_in->cap_id);
> +	cmd.params.get_cap_in.property_id = cpu_to_be32(cap_in->property_id);
> +	cmd.params.get_cap_in.property_cnt = cpu_to_be32(cap_in->property_cnt);
> +
> +	rc = tpm_transmit_cmd(chip, (const char *) &cmd, sizeof(cmd), 0,
> +			      "attempting get capability operation");
> +	if (rc < 0)
> +		return rc;
> +	cap_id = be32_to_cpu(cmd.params.get_cap_out.cap_data.cap_id);
> +
> +	switch (cap_id) {
> +	case TPM2_CAP_PCRS:
> +		memcpy(&cap_out->cap_data, &cmd.params.get_cap_out.cap_data,
> +		       sizeof(cmd.params.get_cap_out.cap_data));
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return rc;

I think it would be better to start with a function that grabs one
attribute and call that in a loop. Performance is not an issue here and
you are storing the result. Simpler is really better in this case.

Rather refactor tpm2_get_tpm_pt to be more generic and call that in a
loop. I don't think the performance is really an issue here and you
anyway store the result to struct tpm_chip. Also, your implementation is
not generic (more_data is not taken into account).

I just sent patches that I've written for the access broker [1]. I think
it'd be better if you would use them in your patch set.

[1] https://lkml.org/lkml/2016/10/9/49

/Jarkko 

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
