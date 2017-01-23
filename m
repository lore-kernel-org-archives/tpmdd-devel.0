From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC v4 1/5] tpm: validate TPM 2.0 commands
Date: Mon, 23 Jan 2017 23:44:35 +0200
Message-ID: <20170123214435.6aa75rgy6b3gdfpv@intel.com>
References: <20170122234438.12102-1-jarkko.sakkinen@linux.intel.com>
	<20170122234438.12102-2-jarkko.sakkinen@linux.intel.com>
	<b5837ab8-0edd-86cf-c17d-36d55754219e@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b5837ab8-0edd-86cf-c17d-36d55754219e-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Jan 22, 2017 at 09:02:17PM -0500, Stefan Berger wrote:
> On 01/22/2017 06:44 PM, Jarkko Sakkinen wrote:
> > @@ -1025,8 +1029,60 @@ int tpm2_auto_startup(struct tpm_chip *chip)
> >   		}
> >   	}
> > 
> > +	rc = tpm2_get_tpm_pt(chip, TPM_PT_TOTAL_COMMANDS, &nr_commands, NULL);
> > +	if (rc)
> > +		goto out;
> > +
> > +	/* sanity check */
> > +	if (nr_commands > INT_MAX) {
> > +		rc = -E2BIG;
> > +		goto out;
> > +	}
> > +
> > +	chip->cc_attrs_tbl = devm_kzalloc(&chip->dev, 4 * nr_commands,
> > +					  GFP_KERNEL);
> > +
> > +	rc = tpm_buf_init(&buf, TPM2_ST_NO_SESSIONS, TPM2_CC_GET_CAPABILITY);
> > +	if (rc)
> > +		goto out;
> > +
> > +	tpm_buf_append_u32(&buf, TPM2_CAP_COMMANDS);
> > +	tpm_buf_append_u32(&buf, TPM2_CC_FIRST);
> > +	tpm_buf_append_u32(&buf, nr_commands);
> > +
> > +	rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, 0, NULL);
> 
> You should probably pass the min_rsp_body_size as 5 + 4 + nr_commands * 4

Thanks. I'll put 9 + 4 * nr_commands as the expected size.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
