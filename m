From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: Re: [tpmdd-devel] [PATCH] tpm: improve tpm_tis send()
 performance by ignoring burstcount
Date: Mon, 14 Aug 2017 08:03:05 -0400
Message-ID: <1502712185.6179.20.camel@linux.vnet.ibm.com>
References: <20170807114632.1339-1-nayna@linux.vnet.ibm.com>
         <E37DFCB0-2E74-45F6-B2DF-70EF59F310BC@gmx.de>
         <20170808191145.kggmoczd5laiccrn@linux.intel.com>
         <db0359cc-5e6b-2055-734a-bd9104e4a99f@linux.vnet.ibm.com>
         <trinity-b615e596-8095-4a0a-9922-3fa9a5724c30-1502312435959@3c-app-gmx-bs76>
         <20170811111421.bg2we53rdeecjtac@linux.intel.com>
         <1502465419.3579.109.camel@linux.vnet.ibm.com>
         <20170814105130.4jjdcop4mqkoxhgh@linux.intel.com>
         <20170814105651.eo3e7tokt7mujeba@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170814105651.eo3e7tokt7mujeba@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Ken Goldman <kgold@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-08-14 at 13:56 +0300, Jarkko Sakkinen wrote:

> > > > I would like to see tpm_msleep() wrapper to replace current msleep()
> > > > usage across the subsystem before considering this. I.e. wrapper that
> > > > internally uses usleep_range(). This way we can mechanically convert
> > > > everything to a more low latency option.
> > > 
> > > Fine.  I assume you meant tpm_sleep(), not tpm_msleep().
> > 
> > I think it would sense to have a function that takes msecs because msecs
> > are mostly used everywhere in the subsystem. This way we don't have to
> > change any of the existing constants.

For now converting from msleep() to tpm_msleep() will be straight
forward.  Internally we would just use usleep_range().

Going forward, my concern is that even 1 msec might be too long for
some of these sleeps.

Mimi

 

