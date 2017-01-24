From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH RFC] tpm: define a command filter
Date: Mon, 23 Jan 2017 17:19:18 -0700
Message-ID: <20170124001918.GA29735@obsidianresearch.com>
References: <20170124000258.16818-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170124000258.16818-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 24, 2017 at 02:02:52AM +0200, Jarkko Sakkinen wrote:
> This commit adds a command filter for whitelisting a set of commands in
> a TPM space. When a TPM space is created through /dev/tpms0, no
> commands are allowed. The user of the TPM space must explicitly define
> the list of commands allowed before sending any commands. This ioctl is
> a one shot call so that a resource manager daemon can call it before
> sending the file descriptor to the client.

I don't think it makes sense to have a daemon in user space that
passes an open'd /dev/tpms0 FD directly to a client..

It is trivial and more powerful to just proxy the messages. Can you
see some reason why passing a FD through a daemon would make sense?

The earlier discussion with James was to have some way to apply a
global command filter to all tpms0 users with the idea that the
'right' restricted command set would enable a 0666 cdev node, and no
daemon.

> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 1. This patch applies on top of 'tabrm4' brach.
> 2. Only compilation is tested (just drafted the idea)
>  drivers/char/tpm/tpm-interface.c | 12 +++++--
>  drivers/char/tpm/tpm.h           |  1 +
>  drivers/char/tpm/tpm2-space.c    |  7 ++++
>  drivers/char/tpm/tpms-dev.c      | 75 ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/tpms.h        | 29 ++++++++++++++++

BTW, don't forget to update kbuild when you add uapi files... Applies
to other patches..

Jason
