From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH v2 0/2] tpm: enhance TPM 2.0 extend
 function to support multiple PCR banks
Date: Tue, 03 Jan 2017 07:27:49 -0500
Message-ID: <1483446469.2900.30.camel@linux.vnet.ibm.com>
References: <1483124550-9529-1-git-send-email-nayna@linux.vnet.ibm.com>
         <20170102221550.pck4fwir77zss6lz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170102221550.pck4fwir77zss6lz@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-01-03 at 00:15 +0200, Jarkko Sakkinen wrote:
> On Fri, Dec 30, 2016 at 02:02:28PM -0500, Nayna Jain wrote:
> > IMA extends its hash measurements in the TPM PCRs, based on policy.
> > The existing in-kernel TPM extend function extends only the SHA1
> > PCR bank. TPM 2.0 defines multiple PCR banks, to support different
> > hash algorithms. The TCG TPM 2.0 Specification[1] recommends
> > extending all active PCR banks to prevent malicious users from
> > setting unused PCR banks with fake measurements and quoting them.
> > This patch set adds support for extending all active PCR banks,
> > as recommended.

For this reason, the change is needed whether we're extending the SHA1
bank or any of the other TPM 2.0 banks.

> > The first patch implements the TPM 2.0 capability to retrieve
> > the list of active PCR banks.
> > 
> > The second patch modifies the tpm_pcr_extend() and tpm2_pcr_extend()
> > interface to support extending multiple PCR banks. The existing
> > tpm_pcr_extend() interface expects only a SHA1 digest. Hence, to
> > extend all active PCR banks with differing digest sizes for TPM 2.0,
> > the SHA1 digest is padded with 0's as needed.
> > 
> > This approach is taken to maintain backwards compatibility for IMA
> > in order to continue working with both TPM 1.2 and TPM 2.0 without
> > any changes and still comply with TCG TPM 2.0 Specification[1].
> 
> What is the plan to improve IMA so that it can use better hash
> algorithms? For me this zero padding sounds like a hack.

In one case, we'll be padding the SHA1 hash, while in the other cases we
would be truncating the hash.   Unfortunately, the need to extend
multiple banks doesn't go away when IMA supports larger digests.

Nayna, could you remove this [unnecessary] paragraph?

Mimi

> > [1] TPM 2.0 Specification referred here is "TCG PC Client Specific
> > Platform Firmware Profile for TPM 2.0"
> > 
> > Changelog v2:
> > 
> > - Patch "tpm: implement TPM 2.0 capability to get active PCR banks"
> >   - defined structs definition in tpm2-cmd.c.
> >   - no_of_active_banks field is removed. Instead, constant
> >   TPM2_MAX_PCR_BANKS is defined.
> >   - renamed tpm2_get_active_pcr_banks() to tpm2_get_pcr_allocation()
> >   - removed generic function tpm2_get_capability().
> > 
> > - Patch "tpm: enchance TPM 2.0 PCR extend to support multiple banks"
> >  - Removed tpm2.h, and defined structs common for extend and event log
> >   in tpm_eventlog.h
> >  - uses tpm_buf in tpm2_pcr_extend().
> > 
> > Nayna Jain (2):
> >   tpm: implement TPM 2.0 capability to get active PCR banks
> >   tpm: enhance TPM 2.0 PCR extend to support multiple banks
> > 
> >  drivers/char/tpm/tpm-interface.c |  16 ++++-
> >  drivers/char/tpm/tpm.h           |   8 ++-
> >  drivers/char/tpm/tpm2-cmd.c      | 146 +++++++++++++++++++++++++++++++--------
> >  drivers/char/tpm/tpm_eventlog.h  |  15 ++++
> >  4 files changed, 153 insertions(+), 32 deletions(-)
> > 
> > -- 
> > 2.5.0
> > 
> 
> ------------------------------------------------------------------------------
> Check out the vibrant tech community on one of the world's most 
> engaging tech sites, SlashDot.org! http://sdm.link/slashdot
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
> 


