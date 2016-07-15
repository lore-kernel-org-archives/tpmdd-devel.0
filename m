From: Andrey Pronin <apronin@chromium.org>
Subject: Re: [PATCH 2/2] tpm: fix byte-order for the value read by
 tpm2_get_tpm_pt
Date: Fri, 15 Jul 2016 12:31:43 -0700
Message-ID: <20160715193143.GA7052@apronin>
References: <1468544838-9990-1-git-send-email-apronin@chromium.org>
 <1468544838-9990-3-git-send-email-apronin@chromium.org>
 <20160715031046.GC9347@obsidianresearch.com>
 <20160715031701.GA25406@apronin>
 <20160715033553.GJ9347@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160715033553.GJ9347@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, groeck@chromium.org, smbarber@chromium.org, dianders@chromium.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 14, 2016 at 09:35:53PM -0600, Jason Gunthorpe wrote:
> On Thu, Jul 14, 2016 at 08:17:01PM -0700, Andrey Pronin wrote:
> > conversion. The only place tpm2_get_tpm_pt() was used before was in
> > tpm2_gen_interrupt, which discarded the result. So, nobody noticed,
> > I guess.
> 
> If you have a moment can you run sparse on this file before/after this
> change and make sure it did complain and that there are not other
> endian errors?
> 

I ran sparse. In my case it didn't complain before or after the change.
It only complains about using cpu_to_be32() in tpm_capabilities and
tpm_sub_capabilities enum in tpm.h and the use of those enums in
tpm_getcap() in tpm-interface.c

I even tried changing the code there to
	__be32 vv = cmd.params.get_tpm_pt_out.value;
	u32 ret = vv;
to make it clear what's going on. Still, no complaints from sparse.

be32_to_cpu() should cleary be done in this case, though. As value
is defined as __be32 in struct tpm2_get_tpm_pt_out, and we return u32
in that parameter from tpm2_get_tpm_pt(). Plus, it's consistent with
the spec. It's just nobody has used this value yet in the existing
code, thus it went unnoticed.

To address "no dead code" comment, I'll drop defining various tpm2
properties and bits from this patchset and move it to the sysfs for
tpm2 patchset where they'll be needed for tpm2-specific attributes.
But this fix is valid on its own in my opinion.
