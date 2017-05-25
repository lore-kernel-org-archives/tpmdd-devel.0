From: Josh Zimmerman <joshz@google.com>
Subject: Re: [PATCH v3] Add "shutdown" to "struct class".
Date: Thu, 25 May 2017 09:24:30 -0700
Message-ID: <CAHSjozC4N7ShgCqNPbvycrhe17e3NKVik92Gy0vAHqBvBm-oAA@mail.gmail.com>
References: <20170515173438.13420-1-joshz@google.com> <20170525130930.GA16244@kroah.com>
 <CAHSjozAkGo1OnjK8HO3m1YyAwamd4CNZ9rUNiwmBeQz6Gau9VA@mail.gmail.com> <20170525160925.GA25318@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170525160925.GA25318@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, May 25, 2017 at 9:09 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, May 25, 2017 at 08:40:28AM -0700, Josh Zimmerman wrote:
>> Thanks, Greg.
>>
>> Greg, Jarkko: Do either of you you have any objections to me
>> backporting these changes to 4.4 and 4.9? I'd like to make sure that
>> at least the couple most recent LTS kernels have this patch.
>
> Why?  What bug does this solve?
If a TPM2 device has power removed without a TPM2_Shutdown being
issued, it will increment its "dictionary attack" counter. After that
counter reaches a certain value, the TPM2 device will lock the user
out. Adding the shutdown callback allows the TPM kernel driver to send
TPM2_Shutdown to all TPM2 devices.

> If it meets the rules of
> Documentation/stable_kernel_rules.txt (or whereever that file moved to),
> that's fine with me.
Documentation/process/stable-kernel-rules.rst, right? To comply with
option 1 referred to there (Adding the appropriate "Cc:" to the
description), should I send a new patch email or just reply to this
one and quote the relevant part? (I don't believe the document
specifies.)

Thanks,

Josh
