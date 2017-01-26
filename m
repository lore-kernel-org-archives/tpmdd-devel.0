From: Michal Suchanek <hramrach@gmail.com>
Subject: Re: ibmvtpm byteswapping inconsistency
Date: Thu, 26 Jan 2017 23:43:27 +0100
Message-ID: <CAOMqctQGoa_A9pCppWaDoudmvfgfVe3Vpg+OmUneF4vJ_8xqkg@mail.gmail.com>
References: <20170126212248.3f3e9103@kitsune.suse.cz> <20170126220536.GB31937@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170126220536.GB31937@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Michal Such??nek <msuchanek@suse.de>, Nayna Jain <nayna@linux.vnet.ibm.com>, Ashley Lai <ashleydlai@gmail.com>, Marcel Selhorst <tpmdd@selhorst.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>, Peter Huewe <peterhuewe@gmx.de>, linuxppc-dev@lists.ozlabs.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 26 January 2017 at 23:05, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> On Thu, Jan 26, 2017 at 09:22:48PM +0100, Michal Such??nek wrote:
>
>> This is repeated a few times in the driver so I added memset to quiet
>> gcc and make behavior deterministic in case the unused fields get some
>> meaning in the future.
>
> Yep, reserved certainly needs to be zeroed.. Can you send a patch?

And len and data as well..

> memset is overkill...

Does not look so.

Michal
