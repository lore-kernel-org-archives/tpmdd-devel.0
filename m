From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v6 0/2] enhance TPM 2.0 extend function to
 support multiple PCR banks
Date: Thu, 26 Jan 2017 00:52:52 +0200
Message-ID: <20170125225252.3plzxtl4vpuaayp7@intel.com>
References: <1484931913-24909-1-git-send-email-nayna@linux.vnet.ibm.com>
 <20170125204535.bduqiywtlvgidoj6@intel.com>
 <03751871-ab12-9413-4034-e4efbf020ab4@linux.vnet.ibm.com>
 <20170125220401.6i2icwp4ruiebwpj@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170125220401.6i2icwp4ruiebwpj@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 26, 2017 at 12:04:01AM +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 25, 2017 at 04:08:55PM -0500, Stefan Berger wrote:
> > On 01/25/2017 03:45 PM, Jarkko Sakkinen wrote:
> > > On Fri, Jan 20, 2017 at 12:05:11PM -0500, Nayna Jain wrote:
> > > > IMA extends its hash measurements in the TPM PCRs, based on policy.
> > > > The existing in-kernel TPM extend function extends only the SHA1
> > > > PCR bank. TPM 2.0 defines multiple PCR banks, to support different
> > > > hash algorithms. The TCG TPM 2.0 Specification[1] recommends
> > > > extending all active PCR banks to prevent malicious users from
> > > > setting unused PCR banks with fake measurements and quoting them.
> > > > This patch set adds support for extending all active PCR banks,
> > > > as recommended.
> > > > 
> > > > The first patch implements the TPM 2.0 capability to retrieve
> > > > the list of active PCR banks.
> > > > 
> > > > The second patch modifies the tpm_pcr_extend() and tpm2_pcr_extend()
> > > > interface to support extending multiple PCR banks. The existing
> > > > tpm_pcr_extend() interface expects only a SHA1 digest. Hence, to
> > > > extend all active PCR banks with differing digest sizes for TPM 2.0,
> > > > the SHA1 digest is padded with 0's as needed.
> > > > 
> > > > [1] TPM 2.0 Specification referred here is "TCG PC Client Specific
> > > > Platform Firmware Profile for TPM 2.0"
> > > I pushed these patches. I had to resolve merge conflicts caused
> > > by the min_rsp_body_length parameter in tpm_transmit_cmd. Can you
> > > verify that I didn't break anything?
> > 
> > It looks like this hunk here got into the wrong patch:
> > 
> > @@ -1061,7 +1068,7 @@ ssize_t tpm2_get_pcr_allocation(struct tpm_chip *chip)
> >         tpm_buf_append_u32(&buf, 0);
> >         tpm_buf_append_u32(&buf, 1);
> > 
> > -       rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0,
> > +       rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 9, 0,
> >                               "get tpm pcr allocation");
> >         if (rc < 0)
> >                 goto out;
> 
> Thanks. I'll eventually fix this before sending the next pull request.

I'll actually squash the patches and make it a static function. Its
only call site is tpm2_auto_startup and remove the declaration from
tpm.h. There's no point to have it there.

/Jarkko
