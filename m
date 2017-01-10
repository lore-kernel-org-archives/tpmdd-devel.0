From: Ken Goldman <kgoldman@us.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 10 Jan 2017 14:29:08 -0500
Message-ID: <o53clt$uo9$1@blaine.gmane.org>
References: <kgoldman@us.ibm.com>
 <201701041612.v04GCfPK031525@wind.enjellic.com>
 <20170109231635.6wh25qoy7svcnys6@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20170109231635.6wh25qoy7svcnys6@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/9/2017 6:16 PM, Jarkko Sakkinen wrote:
>
> Here's my cuts for the kernel:
>
> - Kernel virtualizes handle areas. It's mechanical.
> - Kernel does not virtualize bodies. It's not mechanical.
> - At least the first version of the RM will not do other than session
>   isolation for sessions.

Is it correct that "bodies" are the parameter area of the commands and 
responses?

if so, eventually something should virtualize getcapability.  It may be 
safer in user space, but it can mask RM issues.




