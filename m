From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v6 0/2] enhance TPM 2.0 extend function to
 support multiple PCR banks
Date: Sun, 29 Jan 2017 17:19:04 +0200
Message-ID: <20170129151903.v7mpbwqxll4ho73v@intel.com>
References: <1484931913-24909-1-git-send-email-nayna@linux.vnet.ibm.com>
	<20170125204535.bduqiywtlvgidoj6@intel.com>
	<588B81FF.40606@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <588B81FF.40606-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Jan 27, 2017 at 10:53:11PM +0530, Nayna wrote:
> 
> 
> On 01/26/2017 02:15 AM, Jarkko Sakkinen wrote:
> > On Fri, Jan 20, 2017 at 12:05:11PM -0500, Nayna Jain wrote:
> > > IMA extends its hash measurements in the TPM PCRs, based on policy.
> > > The existing in-kernel TPM extend function extends only the SHA1
> > > PCR bank. TPM 2.0 defines multiple PCR banks, to support different
> > > hash algorithms. The TCG TPM 2.0 Specification[1] recommends
> > > extending all active PCR banks to prevent malicious users from
> > > setting unused PCR banks with fake measurements and quoting them.
> > > This patch set adds support for extending all active PCR banks,
> > > as recommended.
> > > 
> > > The first patch implements the TPM 2.0 capability to retrieve
> > > the list of active PCR banks.
> > > 
> > > The second patch modifies the tpm_pcr_extend() and tpm2_pcr_extend()
> > > interface to support extending multiple PCR banks. The existing
> > > tpm_pcr_extend() interface expects only a SHA1 digest. Hence, to
> > > extend all active PCR banks with differing digest sizes for TPM 2.0,
> > > the SHA1 digest is padded with 0's as needed.
> > > 
> > > [1] TPM 2.0 Specification referred here is "TCG PC Client Specific
> > > Platform Firmware Profile for TPM 2.0"
> > 
> > I pushed these patches. I had to resolve merge conflicts caused
> > by the min_rsp_body_length parameter in tpm_transmit_cmd. Can you
> > verify that I didn't break anything?
> > 
> 
> Yes, it looks fine, also tested with it.
> 
> Just to understand.. how did you decide min_rsp_body_length to be 9.
> If I understood correctly, I think it is the size after header, till last
> fixed parameter i.e.  till count.
> Is the assumption is that count can be zero, such that there is no active
> bank for PCR and so no struct tpm2_pcr_selection ?
> 
> Thanks & Regards,
>    - Nayna

Hmm.. I got it from "marker = &buf.data[TPM_HEADER_SIZE + 9];" i.e. must
have at last 9 bytes after the header.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
