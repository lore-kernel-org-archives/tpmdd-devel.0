From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Fwd: Re: [PATCH v9 2/2] tpm: add securityfs
 support, for TPM 2.0 firmware event log
Date: Tue, 31 Jan 2017 17:31:50 -0500
Message-ID: <1485901910.9008.1.camel@linux.vnet.ibm.com>
References: <de409ad1-de39-20d2-bda6-5d2a965e7256@linux.vnet.ibm.com>
	<CALAzByG474T_qSJ0Kry1LiNSsCQAHUagqcqtR_CnpporicZrdg@mail.gmail.com>
	<588F09A2.4090502@linux.vnet.ibm.com>
	<20170131174659.b6njebycqzd5ur6f@intel.com>
	<20170131203452.523ckw4aphxdsndq@intel.com>
	<alpine.LRH.2.20.1702010842220.28891@namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <alpine.LRH.2.20.1702010842220.28891-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Cc: "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kenneth Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-02-01 at 08:46 +1100, James Morris wrote:
> On Tue, 31 Jan 2017, Jarkko Sakkinen wrote:
> 
> > James,
> > 
> > The discussion is about two features:
> > 
> > 1. Extension to tpm_pcr_extend() (used by IMA) to extend all PCR banks
> >    instead of just SHA-1 banks. It is recommended by TCG to do so in
> >    order to prevent malicious use of PCRs.
> > 2. TPM 2.0 event log with backend support for OF device tree (for
> >    getting address where you can grab it).
> > 
> > These are required as baseline to implement full TPM 2.0 support for
> > IMA. The commits are fairly well baked and went through many iterations.
> > I've tested tpm_pcr_extend() patches. I haven't tested event log patches
> > but have extensively reviewed them and Ken Goldman has tested them with
> > POWER hardware.
> > 
> > I don't believe that there is major risk to put them already into 4.11
> > but it is fairly late so I just want a second opinion before putting
> > them into pull request.
> > 
> 
> I'll take this for 4.11.  IMA + TPM 2.0 is still developmental and not in 
> wide use, afaik.

Thank you!   FYI, I've been running with them as well.

Mimi


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
