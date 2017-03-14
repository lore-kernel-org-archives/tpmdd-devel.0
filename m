From: Ken Goldman <kgold@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: Add sysfs interface to show TPM
 hardware version
Date: Tue, 14 Mar 2017 14:18:15 -0400
Message-ID: <9f67321b-50bd-9e6f-61f8-c29ae14f261f@linux.vnet.ibm.com>
References: <1489382517-9078-1-git-send-email-Meng.Li@windriver.com>
 <29B2C361-A0C0-410E-ACCA-07AFA382A251@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <29B2C361-A0C0-410E-ACCA-07AFA382A251@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On 3/13/2017 3:10 AM, Peter Huewe wrote:

> And yes you are right there is currently no way, except for trial and
> error, for the userspace to determine this. So an interface to get
> this information makes sense to me.

In practice, I suspect that a single user space application won't
support both TPMs.  It will send the first command, get an error
response code that says it's the wrong TPM, and exit.

Note that, although there is no overlap in the command API, the packet
format is compatible enough that a meaningful response can be returned.
