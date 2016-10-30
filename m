From: Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: tpm_tis regression in 4.9?
Date: Sun, 30 Oct 2016 11:47:08 +0100
Message-ID: <2305cbf7-ebde-6daa-5590-b4d6f5ae58d1@leemhuis.info>
References: <CALCETrXjWaky05iMXZBGJT8xyQbtbkcL=G9J0vAzEWRHWtMuCg@mail.gmail.com>
 <20161028030916.GA29851@obsidianresearch.com>
 <20161028143745.3iaevn4sunbmuiln@intel.com>
 <20161028171043.GA18206@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161028171043.GA18206@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

FYI: I added this report to the list of regressions for Linux 4.9. I'll
watch this thread for further updates on this issue to document progress
in my weekly reports. Please let me know via regressions@leemhuis.info
in case the discussion moves to a different place (bugzilla or another
mail thread for example). But FWIW: I already know this is discussed in
at least two other places:
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1256705.html
https://www.spinics.net/lists/kernel/msg2372189.html

tia! Ciao, Thorsten

On 28.10.2016 19:10, Jason Gunthorpe wrote:
> On Fri, Oct 28, 2016 at 05:37:45PM +0300, Jarkko Sakkinen wrote:
> 
>>> I think this patch from Jarkko's next is the fix:
>>>
>>> http://git.infradead.org/users/jjs/linux-tpmdd.git/commit/65da72b7ddcdd8990e4783d09c7e86d90ccb4121
>>>
>>> Jarkko? Can you hurry that along to go in for -rc?
>>
>> Do you think I should resend the pull request?
> 
> That or a ping. This patch needs to land right away since it is breaking 4.9.
> 
> Jason
> 
> http://news.gmane.org/find-root.php?message_id=20161028171043.GA18206%40obsidianresearch.com 
> http://mid.gmane.org/20161028171043.GA18206%40obsidianresearch.com
> 
