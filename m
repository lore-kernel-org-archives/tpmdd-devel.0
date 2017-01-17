From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: add session handles to the save and
 restore of the tpm2 space manager
Date: Tue, 17 Jan 2017 18:21:01 +0200
Message-ID: <20170117162101.3usgfxlbug77zeew@intel.com>
References: <1484335453.2527.31.camel@linux.vnet.ibm.com>
 <20170116100415.ieyweqjjcg5d3zzd@intel.com>
 <1484608725.2540.88.camel@linux.vnet.ibm.com>
 <o5l849$el9$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <o5l849$el9$1@blaine.gmane.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Ken Goldman <kgoldman@us.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 17, 2017 at 09:01:59AM -0500, Ken Goldman wrote:
> On 1/16/2017 6:18 PM, James Bottomley wrote:
> >
> > Basically this means that the advice to virtualize session handles
> > in the TCG RM document is wrong and we have to use physical handles.
> > I'll redo the implementation for this ... and now, since we'll have
> > nothing to use as an index, it probably does make sense to have
> > sessions in a separate array.  I can also separate isolation from
> > context switching ... although I really think this is less optimal:
> > my TPM only allows three active context handles, so if we don't
> > context switch them identically to transient object (which it also
> > only allows three of) I'm going to run out.  I actually redid my
> > openssl_tpm_engine patches so they use session handles for parameter
> > encryption and HMAC based authority, so this may end up biting me
> > soon ...
> 
> I think you have to context save sessions, just as you do with transient 
> objects.  Otherwise, only one process at a time can connect.

Isolation is self-contained step that can be tested and possible
regressions catched.

I could even consider landing isolation in one release and swapping in
subsequent in order to keep the release content more digestable for
upper layer maintainers and risk of causing major regressions small.

/Jarkko
