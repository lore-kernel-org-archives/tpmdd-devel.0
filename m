From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v6 0/2] enhance TPM 2.0 extend function to support
 multiple PCR banks
Date: Thu, 26 Jan 2017 01:33:35 +0200
Message-ID: <20170125233335.g5dmj43bgrulwmva@intel.com>
References: <1484931913-24909-1-git-send-email-nayna@linux.vnet.ibm.com>
 <20170125204535.bduqiywtlvgidoj6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170125204535.bduqiywtlvgidoj6@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 25, 2017 at 10:45:35PM +0200, Jarkko Sakkinen wrote:
> On Fri, Jan 20, 2017 at 12:05:11PM -0500, Nayna Jain wrote:
> > IMA extends its hash measurements in the TPM PCRs, based on policy.
> > The existing in-kernel TPM extend function extends only the SHA1
> > PCR bank. TPM 2.0 defines multiple PCR banks, to support different
> > hash algorithms. The TCG TPM 2.0 Specification[1] recommends
> > extending all active PCR banks to prevent malicious users from
> > setting unused PCR banks with fake measurements and quoting them.
> > This patch set adds support for extending all active PCR banks,
> > as recommended.
> > 
> > The first patch implements the TPM 2.0 capability to retrieve
> > the list of active PCR banks.
> > 
> > The second patch modifies the tpm_pcr_extend() and tpm2_pcr_extend()
> > interface to support extending multiple PCR banks. The existing
> > tpm_pcr_extend() interface expects only a SHA1 digest. Hence, to
> > extend all active PCR banks with differing digest sizes for TPM 2.0,
> > the SHA1 digest is padded with 0's as needed.
> > 
> > [1] TPM 2.0 Specification referred here is "TCG PC Client Specific
> > Platform Firmware Profile for TPM 2.0"
> 
> I pushed these patches. I had to resolve merge conflicts caused
> by the min_rsp_body_length parameter in tpm_transmit_cmd. Can you
> verify that I didn't break anything?

You have a bug in tpm2_get_pcr_allocation:

rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 9, 0,
		      "get tpm pcr allocation");
if (rc < 0)
	goto out;

You do not handle TPM error. Can you send a fix for this ASAP?

/Jarkko
