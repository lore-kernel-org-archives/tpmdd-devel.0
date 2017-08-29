From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: [tpmdd-devel] [PATCH RESEND 3/3] tpm-chip: Export TPM device to
 user space even when startup failed
Date: Tue, 29 Aug 2017 15:17:39 +0200
Message-ID: <20170829151739.315ae581@kitsune.suse.cz>
References: <20170824083714.10016-1-Alexander.Steffen@infineon.com>
        <20170824083714.10016-4-Alexander.Steffen@infineon.com>
        <20170825172021.lw3ycxqw63ubrcm2@linux.intel.com>
        <adaaeae32ba64d979abfc4b758c63fc0@MUCSE603.infineon.com>
        <20170829125509.55aylht3ikes3bpy@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170829125509.55aylht3ikes3bpy@linux.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Alexander.Steffen@infineon.com, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

Hello,

On Tue, 29 Aug 2017 15:55:09 +0300
Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:

> On Mon, Aug 28, 2017 at 05:15:58PM +0000,
> Alexander.Steffen@infineon.com wrote:
> > But is that just because nobody bothered to implement the necessary
> > logic or for some other reason?  
> 
> We do not want user space to access broken hardware. It's a huge risk
> for system stability and potentially could be used for evil purposes.
> 
> This is not going to mainline as it is not suitable for general
> consumption. You must use a patched kernel if you want this.
> 
> /Jarkko
> 

It has been pointed out that userspace applications that use direct IO
access exist for the purpose. So using a kernel driver is an
improvement over that if the interface is otherwise sane.

What do you expect is the potential for instability or evil use?

With a kernel driver arbitrating the bus access as it would in any
other case I do not see much potential for instability. If there are
cases when the arbitration fails they can surely be more likely
triggered in cases other than userspace sending arbitrary requests to a
device which is in a state the kernel does not support but otherwise
responsive.

If you really think that accessing a device that is in unsupported
state at boot (as opposed to getting unto unsupported state during
device operation after boot) is a real problem it can be selectable as
compile time option so people who do not want the code do not get it.

Thanks

Michal
