From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Fwd: Re: [tpmdd-devel] [PATCH v9 2/2] tpm: add securityfs
 support,for TPM 2.0 firmware event log
Date: Wed, 01 Feb 2017 08:49:30 -0500
Message-ID: <1485956970.4068.31.camel@linux.vnet.ibm.com>
References: <de409ad1-de39-20d2-bda6-5d2a965e7256@linux.vnet.ibm.com>
         <CALAzByG474T_qSJ0Kry1LiNSsCQAHUagqcqtR_CnpporicZrdg@mail.gmail.com>
         <588F09A2.4090502@linux.vnet.ibm.com>
         <20170131174659.b6njebycqzd5ur6f@intel.com>
         <20170131203452.523ckw4aphxdsndq@intel.com>
         <alpine.LRH.2.20.1702010842220.28891@namei.org>
         <1485901910.9008.1.camel@linux.vnet.ibm.com>
         <20170201103003.ltiqrfukfyoognx2@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170201103003.ltiqrfukfyoognx2@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: James Morris <jmorris@namei.org>, Kenneth Goldman <kgoldman@us.ibm.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-02-01 at 12:30 +0200, Jarkko Sakkinen wrote:
> On Tue, Jan 31, 2017 at 05:31:50PM -0500, Mimi Zohar wrote:
> > On Wed, 2017-02-01 at 08:46 +1100, James Morris wrote:
> > > On Tue, 31 Jan 2017, Jarkko Sakkinen wrote:
> > > 
> > > > James,
> > > > 
> > > > The discussion is about two features:
> > > > 
> > > > 1. Extension to tpm_pcr_extend() (used by IMA) to extend all PCR banks
> > > >    instead of just SHA-1 banks. It is recommended by TCG to do so in
> > > >    order to prevent malicious use of PCRs.
> > > > 2. TPM 2.0 event log with backend support for OF device tree (for
> > > >    getting address where you can grab it).
> > > > 
> > > > These are required as baseline to implement full TPM 2.0 support for
> > > > IMA. The commits are fairly well baked and went through many iterations.
> > > > I've tested tpm_pcr_extend() patches. I haven't tested event log patches
> > > > but have extensively reviewed them and Ken Goldman has tested them with
> > > > POWER hardware.
> > > > 
> > > > I don't believe that there is major risk to put them already into 4.11
> > > > but it is fairly late so I just want a second opinion before putting
> > > > them into pull request.
> > > > 
> > > 
> > > I'll take this for 4.11.  IMA + TPM 2.0 is still developmental and not in 
> > > wide use, afaik.
> > 
> > Thank you!   FYI, I've been running with them as well.
> > 
> > Mimi
> 
> OK, so can I also add your Tested-by to these four commits?

I provided Ken with the firmware event log, IMA measurement list, and
the PCRs for testing.   Ken's tested-by is fine.  Missing is Stefan's
tested-by - https://sourceforge.net/p/tpmdd/mailman/message/35602588/
I would really appreciate your adding his tested-by.

thanks,

Mimi

